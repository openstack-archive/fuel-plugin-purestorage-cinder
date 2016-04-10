.. raw:: pdf

    PageBreak

User Guide
==========

| Once the OpenStack instance is deployed by Fuel the Pure Storage plugin provides no
  user configurable or maintainable options.

| Validation of the plugins correct operation can be performed by comparing the parameters selected in the Fuel GUI to those added into the
  ``/etc/cinder/cinder.conf`` and ``/etc/nova/nova.conf`` files on the Controller and Compute nodes respectively.

| As part of this installation a new multipath.conf file is provided to all nodes. Ensure that other device entries required for your
  local environment are added to these files and multipath is restarted to accept any changes.

| The Pure Storage driver (Once configured by Fuel) will output all logs into the
  cinder-volume process log file with the 'Pure Storage' title.
