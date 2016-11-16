.. raw:: pdf

    PageBreak

Installation Guide
==================

Pure Storage Cinder Plugin installation
---------------------------------------

1. Download the plugin from the `Fuel Plugins Catalog <https://www.mirantis.com/products/openstack-drivers-and-plugins/fuel-plugins/>`_.

2. Copy the plugin to an already installed Fuel Master node. If you do not
   have the Fuel Master node yet, please follow `the instructions <https://docs.mirantis.com/openstack/fuel/fuel-9.1/quickstart-guide/index.html>`_:

   # scp fuel-plugin-purestorage-cinder-3.0-3.0.0-1.noarch.rpm root@:<the_Fuel_Master_node_IP>:/tmp``

3. Log into the Fuel Master node.

4. Install the plugin

   # cd /tmp
   # fuel plugins --install fuel-plugin-purestorage-cinder-3.0-3.0.0-1.noarch.rpm

5. Check if the plugin was installed successfully

..

   # fuel plugins
     id | name                           | version | package_version
     ---|--------------------------------|---------|----------------
     1  | fuel-plugin-purestorage-cinder | 3.0.0   | 4.0.0

6. After the plugin is installed, `create a new OpenStack environment <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/create-environment.html>`_ using the Fuel UI Wizard.

7. `Configure your environment <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/configure-environment.html>`_.

8. Open the Settings tab of the Fuel Web UI and scroll down the page. Select the Storage section to enable Pure Storage driver in Cinder plugin checkbox.

  .. image:: ./_static/cinder-purestorage-mitaka-plugin-1.png
     :width: 100%
  .. image:: ./_static/cinder-purestorage-mitaka-plugin-2.png
     :width: 100%
  .. image:: ./_static/cinder-purestorage-mitaka-plugin-3.png
     :width: 100%

9. Enter the Purity API Token and the IP address of the management VIP of the Pure Storage FlashArray.

* Obtain the Purity API token from the Pure Storage GUI

     *System->Users->API Tokens: Select User, click gear icon by user and select 'Show API Token'*

  .. image:: ./_static/api-Collection.png
     :width: 100%

or use the following Purity CLI command to obtain the API token:

   # pureadmin list --api-token --expose <USER>

* Obtain the Pure Storage VIP from the Pure Storage GUI

     *System->System->Configuration->Networking: Use the IP address associated with 'vir0'*

  .. image:: ./_static/VIP-Collection.png
     :width: 100%

or use the following Purity CLI command to obtain the VIP address:

   # purenetwork list vir0

10. Select the defaults for all other Pure Storage options. Each selectable option has a description in the Fuel GUI.

11. If using Fibre Channel as the storage protocol you need to select the zoning method to be used in your deployment. If you are configuring your own zones then select 'Manual' but you can select 'Automatic' if you wish to use the Openstack Fibre Channel Zone Manager. If 'Automatic' is selected you will need to provide the necessary information for the Zone Manager to communicate and configure your fibre channel switches.

  .. image:: ./_static/fc-options.png
     :width: 100%

12. If configuring Cinder replication to a remote Pure Storage FlashArray then it is necessary to provide both the Management IP address of the target array and its API token. Replication of volumes will be performed using the default values provided by the driver, but these can be overriden in the plugin by selecting 'Manual' in the Replication Retention Configuration section of the plugin. On selecting this you will be presented with the default options that are adjustable.

  .. image:: ./_static/replication-options.png
     :width: 100%
