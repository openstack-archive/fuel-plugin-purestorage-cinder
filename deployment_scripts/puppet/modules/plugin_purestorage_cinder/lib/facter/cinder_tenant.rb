require 'facter'

Facter.add("cinder_tenant") do
  setcode do
    tenant = Facter::Util::Resolution.exec('/usr/bin/openstack project show cinder_internal_tenant | grep id | awk \'{print $4}\')
  end
end
