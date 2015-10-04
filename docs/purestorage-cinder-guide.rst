**************************************************************
Guide to the Pure Storage Cinder Plugin version 1.0.0 for Fuel
**************************************************************

This document provides instructions for installing, configuring and using
Pure Storage Cinder plugin for Fuel.

Pure Storage Cinder
===================

The Pure Storage Cinder Fuel plugin provides an automated method
to insert the necessary lines into the cinder.conf file. The plugin
extends the Fuel GUI to provide the necessary entry locations for the
information for the configuration file.

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
Fuel                      7.0

============================================

Limitations
-----------

The Pure Storage Cinder Fuel plugin provides the ability to
create a configuarion file stanza such that when multi-backend support
is selected the stanza is correct.

Installation Guide
==================

Provide step-by-step instructions for plugin installation.
If plugin requires pre-installation steps like backend configuration,
you should also add this information here.

Pure Storage Cinder Plugin installation
--------------------------

1. Download the plugin from Fuel Plugins Catalog.
2. Copy the plugin on already installed Fuel Master node. If you do not
   have the Fuel Master node yet, see Quick Start Guide

  ::
     scp  fuel-plugin-purestorage-cinder-1.0-1.0.0.noarch.rpm root@:<the_Fuel_Master_node_IP>:/tmp

3. Log into the Fuel Master node.
4. Install the plugin:

   ::

     cd /tmp
     fuel plugins --install /tmp/fuel-plugin-purestorage-cinder-1.0-1.0.0.noarch.rpm

4. After plugin is installed, create a new OpenStack environment.
5. Configure your environment.
6. Open the Settings tab of the Fuel web UI and scroll down the page. Select the
   Fuel plugin to enable Pure Storage driver in Cinder plugin checkbox
7. Enter the Purity API Token and the IP address of the management VIP of the Pure Storage FlashAtray
8. Select the defaults for all other Pure Storage options.

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

N/A
