**************************************************************
Guide to the Pure Storage Cinder Plugin version 2.0.0 for Fuel
**************************************************************

This document provides instructions for installing, configuring and using
Pure Storage Cinder plugin for Fuel.

Pure Storage Cinder
===================

The Pure Storage Cinder Fuel plugin provides an automated method
to insert the necessary lines into the ``cinder.conf`` file. The plugin
extends the Fuel Web UI to provide the necessary entry locations for the
information for the configuration file. Thus, the plugin incorporates
`OpenStack Cinder Driver for Pure Storage Flash Array <http://stackalytics.com/report/driverlog?project_id=openstack%2Fcinder&vendor=Pure%20iSCSI%2FFC%20Storage>`_.
Thus, the plugin provides the ability to
create a configuration file stanza so that when multi-backend support
is selected, the stanza is correct.

License
-------

=======================   ==================
Component                  License type
=======================   ==================
No Components are present

============================================

Requirements
------------

=======================   ==================
Requirement                 Version/Comment
=======================   ==================
Fuel                      8.0

============================================

Limitations
-----------

No limitations are present

Installation Guide
==================
Make sure your Pure Storage Flash Array is up and running.
For more information on the Array configuration, follow
the official documentation available on the `Pure Storage
Community Website <http://community.purestorage.com/ekgav24373/attachments/ekgav24373/pure-storage-knowledge/294/1/Purity%204.5%20FlashArray%20User%20Guide.pdf>`_.

Pure Storage Cinder Plugin installation
--------------------------

#. Download the plugin from the `Fuel Plugins Catalog <https://www.mirantis.com/products/openstack-drivers-and-plugins/fuel-plugins/>`_.

#. Copy the plugin to an already installed Fuel Master node. If you do not
   have the Fuel Master node yet, please follow `the instructions <https://docs.mirantis.com/openstack/fuel/fuel-7.0/quickstart-guide.html#quickstart-guide>`_:

   ::

     scp  fuel-plugin-purestorage-cinder-2.0-2.0.0.noarch.rpm root@:<the_Fuel_Master_node_IP>:/tmp

#. Log into the Fuel Master node.

#. Install the plugin

   ::

     cd /tmp
     fuel plugins --install fuel-plugin-purestorage-cinder-2.0-2.0.0.noarch.rpm

#. Check if the plugin was installed successfully

  ::

    # fuel plugins
    id | name                           | version | package_version
    ---|--------------------------------|---------|----------------
     1 | fuel-plugin-purestorage-cinder | 2.0.0   | 2.0.0

#. After the plugin is installed, `create a new OpenStack environment <https://docs.mirantis.com/openstack/fuel/fuel-7.0/user-guide.html#create-a-new-openstack-environment>`_ using the Fuel UI Wizard.

#. `Configure your environment <https://docs.mirantis.com/openstack/fuel/fuel-7.0/user-guide.html#configure-your-environment>`_.

#. Open the Settings tab of the Fuel Web UI and scroll down the page. Select the
   Fuel plugin to enable Pure Storage driver in Cinder plugin checkbox.

  .. image:: figures/fuel-settings-page.png
         :width: 100%

#. Enter the Purity API Token and the IP address of the management VIP of the Pure Storage FlashArray.

#. Select the defaults for all other Pure Storage options.

User Guide
==========

Once the OpenStack instance is deployed by Fuel the Pure Storage plugin provides no
user configurable or maintainable options.

The Pure Storage driver (Once configured by Fuel) will output all logs into the
cinder-volume process log file with the 'Pure Storage' title.

Known issues
============

There are no known issues at this time.

Appendix
========

#. `OpenStack Cinder Driver for Pure Storage Flash Array <http://stackalytics.com/report/driverlog?project_id=openstack%2Fcinder&vendor=Pure%20iSCSI%2FFC%20Storage>`_

#. `Pure Storage Flash Array User Guide <http://community.purestorage.com/ekgav24373/attachments/ekgav24373/pure-storage-knowledge/294/1/Purity%204.5%20FlashArray%20User%20Guide.pdf>`_
