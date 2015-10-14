#
# Configures Cinder volume PureStorage driver.
# Parameters are particular to each volume driver.
#
# === Parameters
#
# [*san_ip*]
#   (required) IP address of PureStorage management VIP.
#
# [*pure_api_token*]
#   (required) API token for management of PureStorage array.
#
# [*volume_backend_name*]
#   (optional) Allows for the volume_backend_name to be separate of $name.
#   Defaults to: $name
#
# [*use_multipath_for_image_xfer*]
#   (optional) .
#   Defaults to True
#
# [*pure_use_chap*]
#   (optional) Only affects the PureISCSIDriver.
#   Defaults to False
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the backend stanza.
#   Defaults to: {}
#   Example :
#     { 'pure_backend/param1' => { 'value' => value1 } }
#

define plugin_purestorage_cinder::backend::pure(
  $san_ip,
  $pure_api_token,
  $volume_backend_name          = $name,
  $pure_storage_protocol        = 'iSCSI',
  $use_chap_auth                = false,
  $use_multipath_for_image_xfer = true,
  $extra_options                = {},
) {

  $volume_driver = $pure_storage_protocol ? {
    'FC'    => 'cinder.volume.drivers.pure.PureFCDriver',
    'iSCSI' => 'cinder.volume.drivers.pure.PureISCSIDriver'
  }

  cinder_config {
    "${name}/volume_backend_name":           value => $volume_backend_name;
    "${name}/volume_driver":                 value => $volume_driver;
    "${name}/san_ip":                        value => $san_ip;
    "${name}/pure_api_token":                value => $pure_api_token, secret => true;
    "${name}/use_chap_auth":                 value => $use_chap_auth;
    "${name}/use_multipath_for_image_xfer":  value => $use_multipath_for_image_xfer ;
  }

  create_resources('cinder_config', $extra_options)
}
