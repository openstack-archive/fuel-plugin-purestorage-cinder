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

    Cinder_config<||> ~> Service['cinder_volume']

    service { 'cinder_volume':
      ensure     => running,
      name       => $::cinder::params::volume_service,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }

}
