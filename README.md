fuel-plugin-purestorge-cinder
============

Plugin description
--------------

Pure Storage plugin for Fuel extends Mirantis OpenStack functionality by
adding support for Pure Storage FlashArray block storage array.

The Pure Storage FlashArray is an iSCSI block storage device used as a
Cinder backend.

Requirements
------------

| Requirement                                              | Version/Comment |
|----------------------------------------------------------|-----------------|
| Mirantis OpenStack compatibility                         | >= 7.0          |
| Access to FlashArray VIP via cinder-volume node          |                 |
| Access to FlashArray VIP via compute/cinder-volume nodes |                 |
| iSCSI or FC initiator on all compute/cinder-volume nodes |                 |

Limitations
-----------

Currently Fuel doesn't support multi-backend.

Pure Storage configuration
---------------------

Prior to deployment ensure the following items are complete:
1. For an iSCSI implementation ensure the Pure Storage FlashArray can route 10G Storage Network 
   to all Compute nodes as well as the Cinder Control/Manager node.
2. Create an AD/LDAP account for the Pure Storage cluster to use as the OpenStack Administrator
   account (if no AD/LDAP use the 'pureuser' account).
3. Obtain the management VIP address for the Pure Storage FlashArray

Pure Storage Cinder plugin installation
---------------------------

All of the needed code for using Pure Storage in an OpenStack deployment is
included in the upstream OpenStack distribution.  There are no additional
libraries, software packages or licenses.

Pure Storage plugin configuration
----------------------------
