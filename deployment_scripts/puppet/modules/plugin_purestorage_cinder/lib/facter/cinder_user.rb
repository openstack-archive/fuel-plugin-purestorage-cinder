require 'facter'

Facter.add('cinder_user') do
  setcode do
    Factor::Core::Execution.exec('/usr/bin/openstack user show cinder_internal_user | grep id | awk \'{print $4}\')
  end
end
