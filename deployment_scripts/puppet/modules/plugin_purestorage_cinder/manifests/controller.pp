#    Copyright 2015 Pure Storage, Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
#

class plugin_purestorage_cinder::controller (
    $backend_name  = 'pure',
    $backends      = ''
) {

    include plugin_purestorage_cinder::common
    include ::cinder::params
    include ::cinder::client
    include ::keystone::client

    package {"purestorage":
      ensure => "installed",
      provider => pip
    }

    $plugin_settings = hiera('fuel-plugin-purestorage-cinder')

    if $::cinder::params::volume_package {
      package { $::cinder::params::volume_package:
        ensure => present,
      }
      Package[$::cinder::params::volume_package] -> Cinder_config<||>
    }

    if $plugin_settings['multibackend'] {
      $section = $backend_name
      cinder_config {
        "DEFAULT/enabled_backends": value => "${backend_name},${backends}";
      }
    } else {
      $section = 'DEFAULT'
    }

    cinder::backend::pure { $section :
      san_ip                        => $plugin_settings['pure_san_ip'],
      pure_api_token                => $plugin_settings['pure_api'],
      volume_backend_name           => $section,
      use_chap_auth                 => $plugin_settings['pure_chap'],
      use_multipath_for_image_xfer  => $plugin_settings['pure_multipath'],
      pure_storage_protocol         => $plugin_settings['pure_protocol'],
      extra_options                 => { "$section/backend_host" => { value => $section },
                                         "$section/image_volume_cache_enabled" => { value => $plugin_settings["pure_glance_image_cache"] }
    }
    }

# Insert Glance Image Cache for Cinder settings
    if $plugin_settings['image_volume_cache_enabled'] {
        keystone_tenant { 'cinder_internal_tenant':
                             ensure  => present,
                             description => 'Cinder Internal Tenant',
                             enabled => True,
        }
        keystone_user { 'cinder_internal_user':
                             ensure  => present,
                             description => 'Cinder Internal User',
                             enabled => True,
        }
        keystone_role { 'admin':
                             ensure => present,
        }
        keystone_user_role { 'cinder_internal_user@cinder_internal_tenant':
                             roles => ['admin'],
                             ensure => present
        }
# How do I get back the IDs.
       }
      cinder::backend::pure { DEFAULT :
        extra_options               => { "DEFAULT/cinder_internal_tenant_project_id" => { value => "$PROJECT_ID"] },
                                         "DEFALUT/cinder_internal_tenant_user_id" => { value => "$USER_ID"] }
        }
       }
      cinder::backend::pure { $section :
        extra_options               => { "$section/image_volume_cache_max_count" => { value => $plugin_settings["pure_glance_cache_count"] },
                                         "$section/image_volume_cache_max_size_gb" => { value => $plugin_settings["pure_glance_cache_size"] }
        }
    }

# If protocol is FC hen meed to add zoning_mode. Put in $section as this has already been set by multibackend
    if $plugin_settings['pure_protocol'] == 'FC' {
      cinder_config {
        "$section/zoning_mode": value => "Fabric";
      }
# Now add in the [fc-zone-manager] stanza
    case $plugin_settings['pure_switch_vendor'] {
        'Brocade':    {
                         cinder_config {
                           "fc-zone-manager/brcd_sb_connector": value => "cinder.zonemanager.drivers.brocade.brcd_fc_zone_client_cli.BrcdFCZoneClientCLI";
                           "fc-zone-manager/fc_san_lookup_service": value => "cinder.zonemanager.drivers.brocade.brcd_fc_san_lookup_service.BrcdFCSanLookupService";
                           "fc-zone-manager/zone_driver": value => "cinder.zonemanager.drivers.brocade.brcd_fc_zone_driver.BrcdFCZoneDriver";
                         }
                      }
        'Cisco':      {
                         cinder_config {
                           "fc-zone-manager/cisco_sb_connector": value => "cinder.zonemanager.drivers.cisco.cisco_fc_zone_client_cli.CiscoFCZoneClientCLI";
                           "fc-zone-manager/fc_san_lookup_service": value => "cinder.zonemanager.drivers.cisco.cisco_fc_san_lookup_service.CiscoFCSanLookupService";
                           "fc-zone-manager/zone_driver": value => "cinder.zonemanager.drivers.cisco.cisco_fc_zone_driver.CiscoFCZoneDriver";
                         }
                      }
    }
    case $plugin_settings['pure_fabric_count'] {
        '1':   {
                  cinder_config {
                    "fc-zone-manager/fc_fabric_names": value => $plugin_settings["pure_fabric_name_1"];
                  }
               }
        '2':   {
                  cinder_config {
                    "fc-zone-manager/fc_fabric_names": value => join($plugin_settings["pure_fabric_name_1"],', ',$plugin_settings["pure_fabric_name_2"]);
                  }
               }
    }

    $fabric_zone_1 = $plugin_settings["pure_fabric_name_1"]
    $fabric_zone_2 = $plugin_settings["pure_fabric_name_2"]

# Now add in stanzas for each fabric zone
    case $plugin_settings['pure_switch_vendor'] {
        'Brocade':    {
                        case $plugin_settings['pure_fabric_count'] {
                           '1':   {
                                     cinder_config {
                                        "$fabric_zone_1/fc_fabric_address": value => $plugin_settings["pure_fabric_ip_1"];
                                        "$fabric_zone_1/fc_fabric_user": value => $plugin_settings["pure_username_1"];
                                        "$fabric_zone_1/fc_fabric_password": value => $plugin_settings["pure_password_1"];
                                        "$fabric_zone_1/fc_fabric_port": value => '22';
                                        "$fabric_zone_1/principal_switch_wwn": value => $plugin_settings["pure_principal_wwn_1"];
                                        "$fabric_zone_1/zoning_policy": value => 'initiator-target';
                                        "$fabric_zone_1/zone_activate": value => 'true';
                                        "$fabric_zone_1/zone_name_prefix": value => join($plugin_settings["pure_fabric_name_1"],'_');
                                     }
                                  }
                           '2':   {
                                     cinder_config {
                                        "$fabric_zone_2/fc_fabric_address": value => $plugin_settings["pure_fabric_ip_2"];
                                        "$fabric_zone_2/fc_fabric_user": value => $plugin_settings["pure_username_2"];
                                        "$fabric_zone_2/fc_fabric_password": value => $plugin_settings["pure_password_2"];
                                        "$fabric_zone_2/fc_fabric_port": value => '22';
                                        "$fabric_zone_2/principal_switch_wwn": value => $plugin_settings["pure_principal_wwn_2"];
                                        "$fabric_zone_2/zoning_policy": value => 'initiator-target';
                                        "$fabric_zone_2/zone_activate": value => 'true';
                                        "$fabric_zone_2/zone_name_prefix": value => join($plugin_settings["pure_fabric_name_2"],'_');
                                     }
                                  }
                        }
                      }
        'Cisco':      {
                        case $plugin_settings['pure_fabric_count'] {
                           '1':   {
                                     cinder_config {
                                        "$fabric_zone_1/cisco_fc_fabric_address": value => $plugin_settings["pure_fabric_ip_1"];
                                        "$fabric_zone_1/cisco_fc_fabric_user": value => $plugin_settings["pure_username_1"];
                                        "$fabric_zone_1/cisco_fc_fabric_password": value => $plugin_settings["pure_password_1"];
                                        "$fabric_zone_1/cisco_fc_fabric_port": value => '22';
                                        "$fabric_zone_1/cisco_zoning_vsan": value => $plugin_settings["pure_vsan_1"];
                                        "$fabric_zone_1/cisco_zoning_policy": value => 'initiator-target';
                                        "$fabric_zone_1/cisco_zone_activate": value => 'true';
                                        "$fabric_zone_1/cisco_zone_name_prefix": value => join($plugin_settings["pure_fabric_name_1"],'_');
                                     }
                                  }
                           '2':   {
                                     cinder_config {
                                        "$fabric_zone_2/cisco_fc_fabric_address": value => $plugin_settings["pure_fabric_ip_2"];
                                        "$fabric_zone_2/cisco_fc_fabric_user": value => $plugin_settings["pure_username_2"];
                                        "$fabric_zone_2/cisco_fc_fabric_password": value => $plugin_settings["pure_password_2"];
                                        "$fabric_zone_2/cisco_fc_fabric_port": value => '22';
                                        "$fabric_zone_2/cisco_zoning_vsan": value => $plugin_settings["pure_vsan_2"];
                                        "$fabric_zone_2/cisco_zoning_policy": value => 'initiator-target';
                                        "$fabric_zone_2/cisco_zone_activate": value => 'true';
                                        "$fabric_zone_2/cisco_zone_name_prefix": value => join($plugin_settings["pure_fabric_name_2"],'_');
                                     }
                                  }
                        }
                      }
    }

    Cinder_config<||> ~> Service['cinder_volume']

    service { 'cinder_volume':
      ensure     => running,
      name       => $::cinder::params::volume_service,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }

}
