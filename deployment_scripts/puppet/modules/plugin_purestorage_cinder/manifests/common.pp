#
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
class plugin_purestorage_cinder::common {

  include plugin_purestorage_cinder::params

  package { $plugin_purestorage_cinder::params::pip_package_name:
    ensure => 'installed'
  }
  package { $plugin_purestorage_cinder::params::iscsi_package_name:
    ensure => 'installed'
  }
  package { $plugin_purestorage_cinder::params::multipath_package_name:
    ensure => 'installed'
  }
  case $::osfamily {
    'Debian': {
      service { $plugin_purestorage_cinder::params::iscsi_service_name:
        ensure     => 'running',
        enable     => true,
        hasrestart => true,
        require    => Package[$plugin_purestorage_cinder::params::iscsi_package_name],
      }
      file { '99-pure-storage.rules':
        path    => '/lib/udev/rules.d/99-pure-storage.rules',
        mode    => '0644',
        owner   => root,
        group   => root,
        source  => 'puppet:///modules/plugin_purestorage_cinder/99-pure-storage.rules',
      }
    }
    'RedHat': {
      file { '99-pure-storage.rules':
        path    => '/etc/udev/rules.d/99-pure-storage.rules',
        mode    => '0644',
        owner   => root,
        group   => root,
        source  => 'puppet:///modules/plugin_purestorage_cinder/99-pure-storage.rules',
      }
    }
    default: {
      fail("unsuported osfamily ${::osfamily}, currently Debian and Redhat are the only supported platforms")
    }
  }

  service { $plugin_purestorage_cinder::params::multipath_service_name:
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => false,
    status     => 'pgrep multipathd',
    require    => Package[$plugin_purestorage_cinder::params::multipath_package_name],
  }

  file { 'multipath.conf':
    path    => '/etc/multipath.conf',
    mode    => '0644',
    owner   => root,
    group   => root,
    source  => 'puppet:///modules/plugin_purestorage_cinder/multipath.conf',
    require => Package[$plugin_purestorage_cinder::params::multipath_package_name],
    notify  => Service[$plugin_purestorage_cinder::params::multipath_package_name],
  }
}
