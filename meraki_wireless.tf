
//TODO: @jon-humphries need to ensure that this data model is correct as its currently not validating

# Apply the Meraki Wireless RF Profiles
locals {
  networks_wireless_rf_profiles = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for wireless_rf_profile in try(network.wireless_rf_profiles, []) : {
            network_id = meraki_network.network["${domain.name}/${organization.name}/${network.name}"].id

            data = try(wireless_rf_profile, null)
          } if try(network.wireless_rf_profiles, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_wireless_rf_profile" "net_wireless_rf_profiles" {
  for_each   = { for i, v in local.networks_wireless_rf_profiles : i => v }
  network_id = each.value.network_id

  name                                       = try(each.value.data.name, local.defaults.meraki.networks.networks_wireless_rf_profiles.name, null)
  client_balancing_enabled                   = try(each.value.data.client_balancing_enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.client_balancing_enabled, null)
  min_bitrate_type                           = try(each.value.data.min_bitrate_type, local.defaults.meraki.networks.networks_wireless_rf_profiles.min_bitrate_type, null)
  band_selection_type                        = try(each.value.data.band_selection_type, local.defaults.meraki.networks.networks_wireless_rf_profiles.band_selection_type, null)
  ap_band_settings_band_operation_mode       = try(each.value.data.ap_band_settings.band_operation_mode, local.defaults.meraki.networks.networks_wireless_rf_profiles.ap_band_settings.band_operation_mode, null)
  ap_band_settings_bands_enabled             = try(each.value.data.ap_band_settings.bands.enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.ap_band_settings.bands.enabled, null)
  ap_band_settings_band_steering_enabled     = try(each.value.data.ap_band_settings.band_steering_enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.ap_band_settings.band_steering_enabled, null)
  two_four_ghz_settings_max_power            = try(each.value.data.two_four_ghz_settings.max_power, local.defaults.meraki.networks.networks_wireless_rf_profiles.two_four_ghz_settings.max_power, null)
  two_four_ghz_settings_min_power            = try(each.value.data.two_four_ghz_settings.min_power, local.defaults.meraki.networks.networks_wireless_rf_profiles.two_four_ghz_settings.min_power, null)
  two_four_ghz_settings_min_bitrate          = try(each.value.data.two_four_ghz_settings.min_bitrate, local.defaults.meraki.networks.networks_wireless_rf_profiles.two_four_ghz_settings.min_bitrate, null)
  two_four_ghz_settings_valid_auto_channels  = try(each.value.data.two_four_ghz_settings.valid_auto_channels, local.defaults.meraki.networks.networks_wireless_rf_profiles.two_four_ghz_settings.valid_auto_channels, null)
  two_four_ghz_settings_ax_enabled           = try(each.value.data.two_four_ghz_settings.ax_enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.two_four_ghz_settings.ax_enabled, null)
  two_four_ghz_settings_rxsop                = try(each.value.data.two_four_ghz_settings.rxsop, local.defaults.meraki.networks.networks_wireless_rf_profiles.two_four_ghz_settings.rxsop, null)
  five_ghz_settings_max_power                = try(each.value.data.five_ghz_settings.max_power, local.defaults.meraki.networks.networks_wireless_rf_profiles.five_ghz_settings.max_power, null)
  five_ghz_settings_min_power                = try(each.value.data.five_ghz_settings.min_power, local.defaults.meraki.networks.networks_wireless_rf_profiles.five_ghz_settings.min_power, null)
  five_ghz_settings_min_bitrate              = try(each.value.data.five_ghz_settings.min_bitrate, local.defaults.meraki.networks.networks_wireless_rf_profiles.five_ghz_settings.min_bitrate, null)
  five_ghz_settings_valid_auto_channels      = try(each.value.data.five_ghz_settings.valid_auto_channels, local.defaults.meraki.networks.networks_wireless_rf_profiles.five_ghz_settings.valid_auto_channels, null)
  five_ghz_settings_channel_width            = try(each.value.data.five_ghz_settings.channel_width, local.defaults.meraki.networks.networks_wireless_rf_profiles.five_ghz_settings.channel_width, null)
  five_ghz_settings_rxsop                    = try(each.value.data.five_ghz_settings.rxsop, local.defaults.meraki.networks.networks_wireless_rf_profiles.five_ghz_settings.rxsop, null)
  six_ghz_settings_max_power                 = try(each.value.data.six_ghz_settings.max_power, local.defaults.meraki.networks.networks_wireless_rf_profiles.six_ghz_settings.max_power, null)
  six_ghz_settings_min_power                 = try(each.value.data.six_ghz_settings.min_power, local.defaults.meraki.networks.networks_wireless_rf_profiles.six_ghz_settings.min_power, null)
  six_ghz_settings_min_bitrate               = try(each.value.data.six_ghz_settings.min_bitrate, local.defaults.meraki.networks.networks_wireless_rf_profiles.six_ghz_settings.min_bitrate, null)
  six_ghz_settings_valid_auto_channels       = try(each.value.data.six_ghz_settings.valid_auto_channels, local.defaults.meraki.networks.networks_wireless_rf_profiles.six_ghz_settings.valid_auto_channels, null)
  six_ghz_settings_channel_width             = try(each.value.data.six_ghz_settings.channel_width, local.defaults.meraki.networks.networks_wireless_rf_profiles.six_ghz_settings.channel_width, null)
  six_ghz_settings_rxsop                     = try(each.value.data.six_ghz_settings.rxsop, local.defaults.meraki.networks.networks_wireless_rf_profiles.six_ghz_settings.rxsop, null)
  transmission_enabled                       = try(each.value.data.transmission.enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.transmission.enabled, null)
  per_ssid_settings_0_min_bitrate            = try(each.value.data.per_ssid_settings[0].min_bitrate, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[0].min_bitrate, null)
  per_ssid_settings_0_band_operation_mode    = try(each.value.data.per_ssid_settings[0].band_operation_mode, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[0].band_operation_mode, null)
  per_ssid_settings_0_bands_enabled          = try(each.value.data.per_ssid_settings[0].bands.enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[0].bands.enabled, null)
  per_ssid_settings_0_band_steering_enabled  = try(each.value.data.per_ssid_settings[0].band_steering_enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[0].band_steering_enabled, null)
  per_ssid_settings_1_min_bitrate            = try(each.value.data.per_ssid_settings[1].min_bitrate, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[1].min_bitrate, null)
  per_ssid_settings_1_band_operation_mode    = try(each.value.data.per_ssid_settings[1].band_operation_mode, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[1].band_operation_mode, null)
  per_ssid_settings_1_bands_enabled          = try(each.value.data.per_ssid_settings[1].bands.enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[1].bands.enabled, null)
  per_ssid_settings_1_band_steering_enabled  = try(each.value.data.per_ssid_settings[1].band_steering_enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[1].band_steering_enabled, null)
  per_ssid_settings_2_min_bitrate            = try(each.value.data.per_ssid_settings[2].min_bitrate, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[2].min_bitrate, null)
  per_ssid_settings_2_band_operation_mode    = try(each.value.data.per_ssid_settings[2].band_operation_mode, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[2].band_operation_mode, null)
  per_ssid_settings_2_bands_enabled          = try(each.value.data.per_ssid_settings[2].bands.enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[2].bands.enabled, null)
  per_ssid_settings_2_band_steering_enabled  = try(each.value.data.per_ssid_settings[2].band_steering_enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[2].band_steering_enabled, null)
  per_ssid_settings_3_min_bitrate            = try(each.value.data.per_ssid_settings[3].min_bitrate, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[3].min_bitrate, null)
  per_ssid_settings_3_band_operation_mode    = try(each.value.data.per_ssid_settings[3].band_operation_mode, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[3].band_operation_mode, null)
  per_ssid_settings_3_bands_enabled          = try(each.value.data.per_ssid_settings[3].bands.enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[3].bands.enabled, null)
  per_ssid_settings_3_band_steering_enabled  = try(each.value.data.per_ssid_settings[3].band_steering_enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[3].band_steering_enabled, null)
  per_ssid_settings_4_min_bitrate            = try(each.value.data.per_ssid_settings[4].min_bitrate, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[4].min_bitrate, null)
  per_ssid_settings_4_band_operation_mode    = try(each.value.data.per_ssid_settings[4].band_operation_mode, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[4].band_operation_mode, null)
  per_ssid_settings_4_bands_enabled          = try(each.value.data.per_ssid_settings[4].bands.enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[4].bands.enabled, null)
  per_ssid_settings_4_band_steering_enabled  = try(each.value.data.per_ssid_settings[4].band_steering_enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[4].band_steering_enabled, null)
  per_ssid_settings_5_min_bitrate            = try(each.value.data.per_ssid_settings[5].min_bitrate, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[5].min_bitrate, null)
  per_ssid_settings_5_band_operation_mode    = try(each.value.data.per_ssid_settings[5].band_operation_mode, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[5].band_operation_mode, null)
  per_ssid_settings_5_bands_enabled          = try(each.value.data.per_ssid_settings[5].bands.enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[5].bands.enabled, null)
  per_ssid_settings_5_band_steering_enabled  = try(each.value.data.per_ssid_settings[5].band_steering_enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[5].band_steering_enabled, null)
  per_ssid_settings_6_min_bitrate            = try(each.value.data.per_ssid_settings[6].min_bitrate, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[6].min_bitrate, null)
  per_ssid_settings_6_band_operation_mode    = try(each.value.data.per_ssid_settings[6].band_operation_mode, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[6].band_operation_mode, null)
  per_ssid_settings_6_bands_enabled          = try(each.value.data.per_ssid_settings[6].bands.enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[6].bands.enabled, null)
  per_ssid_settings_6_band_steering_enabled  = try(each.value.data.per_ssid_settings[6].band_steering_enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[6].band_steering_enabled, null)
  per_ssid_settings_7_min_bitrate            = try(each.value.data.per_ssid_settings[7].min_bitrate, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[7].min_bitrate, null)
  per_ssid_settings_7_band_operation_mode    = try(each.value.data.per_ssid_settings[7].band_operation_mode, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[7].band_operation_mode, null)
  per_ssid_settings_7_bands_enabled          = try(each.value.data.per_ssid_settings[7].bands.enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[7].bands.enabled, null)
  per_ssid_settings_7_band_steering_enabled  = try(each.value.data.per_ssid_settings[7].band_steering_enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[7].band_steering_enabled, null)
  per_ssid_settings_8_min_bitrate            = try(each.value.data.per_ssid_settings[8].min_bitrate, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[8].min_bitrate, null)
  per_ssid_settings_8_band_operation_mode    = try(each.value.data.per_ssid_settings[8].band_operation_mode, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[8].band_operation_mode, null)
  per_ssid_settings_8_bands_enabled          = try(each.value.data.per_ssid_settings[8].bands.enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[8].bands.enabled, null)
  per_ssid_settings_8_band_steering_enabled  = try(each.value.data.per_ssid_settings[8].band_steering_enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[8].band_steering_enabled, null)
  per_ssid_settings_9_min_bitrate            = try(each.value.data.per_ssid_settings[9].min_bitrate, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[9].min_bitrate, null)
  per_ssid_settings_9_band_operation_mode    = try(each.value.data.per_ssid_settings[9].band_operation_mode, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[9].band_operation_mode, null)
  per_ssid_settings_9_bands_enabled          = try(each.value.data.per_ssid_settings[9].bands.enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[9].bands.enabled, null)
  per_ssid_settings_9_band_steering_enabled  = try(each.value.data.per_ssid_settings[9].band_steering_enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[9].band_steering_enabled, null)
  per_ssid_settings_10_min_bitrate           = try(each.value.data.per_ssid_settings[10].min_bitrate, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[10].min_bitrate, null)
  per_ssid_settings_10_band_operation_mode   = try(each.value.data.per_ssid_settings[10].band_operation_mode, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[10].band_operation_mode, null)
  per_ssid_settings_10_bands_enabled         = try(each.value.data.per_ssid_settings[10].bands.enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[10].bands.enabled, null)
  per_ssid_settings_10_band_steering_enabled = try(each.value.data.per_ssid_settings[10].band_steering_enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[10].band_steering_enabled, null)
  per_ssid_settings_11_min_bitrate           = try(each.value.data.per_ssid_settings[11].min_bitrate, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[11].min_bitrate, null)
  per_ssid_settings_11_band_operation_mode   = try(each.value.data.per_ssid_settings[11].band_operation_mode, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[11].band_operation_mode, null)
  per_ssid_settings_11_bands_enabled         = try(each.value.data.per_ssid_settings[11].bands.enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[11].bands.enabled, null)
  per_ssid_settings_11_band_steering_enabled = try(each.value.data.per_ssid_settings[11].band_steering_enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[11].band_steering_enabled, null)
  per_ssid_settings_12_min_bitrate           = try(each.value.data.per_ssid_settings[12].min_bitrate, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[12].min_bitrate, null)
  per_ssid_settings_12_band_operation_mode   = try(each.value.data.per_ssid_settings[12].band_operation_mode, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[12].band_operation_mode, null)
  per_ssid_settings_12_bands_enabled         = try(each.value.data.per_ssid_settings[12].bands.enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[12].bands.enabled, null)
  per_ssid_settings_12_band_steering_enabled = try(each.value.data.per_ssid_settings[12].band_steering_enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[12].band_steering_enabled, null)
  per_ssid_settings_13_min_bitrate           = try(each.value.data.per_ssid_settings[13].min_bitrate, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[13].min_bitrate, null)
  per_ssid_settings_13_band_operation_mode   = try(each.value.data.per_ssid_settings[13].band_operation_mode, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[13].band_operation_mode, null)
  per_ssid_settings_13_bands_enabled         = try(each.value.data.per_ssid_settings[13].bands.enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[13].bands.enabled, null)
  per_ssid_settings_13_band_steering_enabled = try(each.value.data.per_ssid_settings[13].band_steering_enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[13].band_steering_enabled, null)
  per_ssid_settings_14_min_bitrate           = try(each.value.data.per_ssid_settings[14].min_bitrate, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[14].min_bitrate, null)
  per_ssid_settings_14_band_operation_mode   = try(each.value.data.per_ssid_settings[14].band_operation_mode, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[14].band_operation_mode, null)
  per_ssid_settings_14_bands_enabled         = try(each.value.data.per_ssid_settings[14].bands.enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[14].bands.enabled, null)
  per_ssid_settings_14_band_steering_enabled = try(each.value.data.per_ssid_settings[14].band_steering_enabled, local.defaults.meraki.networks.networks_wireless_rf_profiles.per_ssid_settings[14].band_steering_enabled, null)
  flex_radios_by_model                       = try(each.value.data.flex_radios.by_model, local.defaults.meraki.networks.networks_wireless_rf_profiles.flex_radios.by_model, null)

}
# Apply the Wireless Settings
locals {
  networks_wireless_settings = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${domain.name}/${organization.name}/${network.name}"].id

          data = try(network.wireless_settings, null)
        } if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_wireless_settings" "net_wireless_settings" {
  for_each   = { for i, v in local.networks_wireless_settings : i => v }
  network_id = each.value.network_id

  meshing_enabled                           = try(each.value.data.meshing_enabled, local.defaults.meraki.networks.networks_wireless_settings.meshing_enabled, null)
  ipv6_bridge_enabled                       = try(each.value.data.ipv6_bridge_enabled, local.defaults.meraki.networks.networks_wireless_settings.ipv6_bridge_enabled, null)
  location_analytics_enabled                = try(each.value.data.location_analytics_enabled, local.defaults.meraki.networks.networks_wireless_settings.location_analytics_enabled, null)
  upgrade_strategy                          = try(each.value.data.upgrade_strategy, local.defaults.meraki.networks.networks_wireless_settings.upgrade_strategy, null)
  led_lights_on                             = try(each.value.data.led_lights_on, local.defaults.meraki.networks.networks_wireless_settings.led_lights_on, null)
  named_vlans_pool_dhcp_monitoring_enabled  = try(each.value.data.named_vlans.pool_dhcp_monitoring.enabled, local.defaults.meraki.networks.networks_wireless_settings.named_vlans.pool_dhcp_monitoring.enabled, null)
  named_vlans_pool_dhcp_monitoring_duration = try(each.value.data.named_vlans.pool_dhcp_monitoring.duration, local.defaults.meraki.networks.networks_wireless_settings.named_vlans.pool_dhcp_monitoring.duration, null)

}
# Apply the Wireless SSIDs
locals {
  networks_wireless_ssids = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for wireless_ssid in try(network.wireless_ssids, []) : {
            network_id = meraki_network.network["${domain.name}/${organization.name}/${network.name}"].id

            data = try(wireless_ssid, null)
          } if try(network.wireless_ssids, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_wireless_ssid" "net_wireless_ssids" {
  for_each   = { for i, v in local.networks_wireless_ssids : i => v }
  network_id = each.value.network_id

  number                                                                      = try(each.value.data.number, local.defaults.meraki.networks.networks_wireless_ssids.number, null)
  name                                                                        = try(each.value.data.name, local.defaults.meraki.networks.networks_wireless_ssids.name, null)
  enabled                                                                     = try(each.value.data.enabled, local.defaults.meraki.networks.networks_wireless_ssids.enabled, null)
  auth_mode                                                                   = try(each.value.data.auth_mode, local.defaults.meraki.networks.networks_wireless_ssids.auth_mode, null)
  enterprise_admin_access                                                     = try(each.value.data.enterprise_admin_access, local.defaults.meraki.networks.networks_wireless_ssids.enterprise_admin_access, null)
  encryption_mode                                                             = try(each.value.data.encryption_mode, local.defaults.meraki.networks.networks_wireless_ssids.encryption_mode, null)
  psk                                                                         = try(each.value.data.psk, local.defaults.meraki.networks.networks_wireless_ssids.psk, null)
  wpa_encryption_mode                                                         = try(each.value.data.wpa_encryption_mode, local.defaults.meraki.networks.networks_wireless_ssids.wpa_encryption_mode, null)
  dot11w_enabled                                                              = try(each.value.data.dot11w.enabled, local.defaults.meraki.networks.networks_wireless_ssids.dot11w.enabled, null)
  dot11w_required                                                             = try(each.value.data.dot11w.required, local.defaults.meraki.networks.networks_wireless_ssids.dot11w.required, null)
  dot11r_enabled                                                              = try(each.value.data.dot11r.enabled, local.defaults.meraki.networks.networks_wireless_ssids.dot11r.enabled, null)
  dot11r_adaptive                                                             = try(each.value.data.dot11r.adaptive, local.defaults.meraki.networks.networks_wireless_ssids.dot11r.adaptive, null)
  splash_page                                                                 = try(each.value.data.splash_page, local.defaults.meraki.networks.networks_wireless_ssids.splash_page, null)
  splash_guest_sponsor_domains                                                = try(each.value.data.splash_guest_sponsor_domains, local.defaults.meraki.networks.networks_wireless_ssids.splash_guest_sponsor_domains, null)
  oauth_allowed_domains                                                       = try(each.value.data.oauth.allowed_domains, local.defaults.meraki.networks.networks_wireless_ssids.oauth.allowed_domains, null)
  local_radius_cache_timeout                                                  = try(each.value.data.local_radius.cache_timeout, local.defaults.meraki.networks.networks_wireless_ssids.local_radius.cache_timeout, null)
  local_radius_password_authentication_enabled                                = try(each.value.data.local_radius.password_authentication.enabled, local.defaults.meraki.networks.networks_wireless_ssids.local_radius.password_authentication.enabled, null)
  local_radius_certificate_authentication_enabled                             = try(each.value.data.local_radius.certificate_authentication.enabled, local.defaults.meraki.networks.networks_wireless_ssids.local_radius.certificate_authentication.enabled, null)
  local_radius_certificate_authentication_use_ldap                            = try(each.value.data.local_radius.certificate_authentication.use_ldap, local.defaults.meraki.networks.networks_wireless_ssids.local_radius.certificate_authentication.use_ldap, null)
  local_radius_certificate_authentication_use_ocsp                            = try(each.value.data.local_radius.certificate_authentication.use_ocsp, local.defaults.meraki.networks.networks_wireless_ssids.local_radius.certificate_authentication.use_ocsp, null)
  local_radius_certificate_authentication_ocsp_responder_url                  = try(each.value.data.local_radius.certificate_authentication.ocsp_responder_url, local.defaults.meraki.networks.networks_wireless_ssids.local_radius.certificate_authentication.ocsp_responder_url, null)
  local_radius_certificate_authentication_client_root_ca_certificate_contents = try(each.value.data.local_radius.certificate_authentication.client_root_ca_certificate.contents, local.defaults.meraki.networks.networks_wireless_ssids.local_radius.certificate_authentication.client_root_ca_certificate.contents, null)
  ldap_servers                                                                = try(each.value.data.ldap.servers, local.defaults.meraki.networks.networks_wireless_ssids.ldap.servers, null)
  ldap_credentials_distinguished_name                                         = try(each.value.data.ldap.credentials.distinguished_name, local.defaults.meraki.networks.networks_wireless_ssids.ldap.credentials.distinguished_name, null)
  ldap_credentials_password                                                   = try(each.value.data.ldap.credentials.password, local.defaults.meraki.networks.networks_wireless_ssids.ldap.credentials.password, null)
  ldap_base_distinguished_name                                                = try(each.value.data.ldap.base_distinguished_name, local.defaults.meraki.networks.networks_wireless_ssids.ldap.base_distinguished_name, null)
  ldap_server_ca_certificate_contents                                         = try(each.value.data.ldap.server_ca_certificate.contents, local.defaults.meraki.networks.networks_wireless_ssids.ldap.server_ca_certificate.contents, null)
  active_directory_servers                                                    = try(each.value.data.active_directory.servers, local.defaults.meraki.networks.networks_wireless_ssids.active_directory.servers, null)
  active_directory_credentials_logon_name                                     = try(each.value.data.active_directory.credentials.logon_name, local.defaults.meraki.networks.networks_wireless_ssids.active_directory.credentials.logon_name, null)
  active_directory_credentials_password                                       = try(each.value.data.active_directory.credentials.password, local.defaults.meraki.networks.networks_wireless_ssids.active_directory.credentials.password, null)
  radius_servers                                                              = try(each.value.data.radius_servers, local.defaults.meraki.networks.networks_wireless_ssids.radius_servers, null)
  radius_proxy_enabled                                                        = try(each.value.data.radius_proxy_enabled, local.defaults.meraki.networks.networks_wireless_ssids.radius_proxy_enabled, null)
  radius_testing_enabled                                                      = try(each.value.data.radius_testing_enabled, local.defaults.meraki.networks.networks_wireless_ssids.radius_testing_enabled, null)
  radius_called_station_id                                                    = try(each.value.data.radius_called_station_id, local.defaults.meraki.networks.networks_wireless_ssids.radius_called_station_id, null)
  radius_authentication_nas_id                                                = try(each.value.data.radius_authentication_nas_id, local.defaults.meraki.networks.networks_wireless_ssids.radius_authentication_nas_id, null)
  radius_server_timeout                                                       = try(each.value.data.radius_server_timeout, local.defaults.meraki.networks.networks_wireless_ssids.radius_server_timeout, null)
  radius_server_attempts_limit                                                = try(each.value.data.radius_server_attempts_limit, local.defaults.meraki.networks.networks_wireless_ssids.radius_server_attempts_limit, null)
  radius_fallback_enabled                                                     = try(each.value.data.radius_fallback_enabled, local.defaults.meraki.networks.networks_wireless_ssids.radius_fallback_enabled, null)
  radius_coa_enabled                                                          = try(each.value.data.radius_coa_enabled, local.defaults.meraki.networks.networks_wireless_ssids.radius_coa_enabled, null)
  radius_failover_policy                                                      = try(each.value.data.radius_failover_policy, local.defaults.meraki.networks.networks_wireless_ssids.radius_failover_policy, null)
  radius_load_balancing_policy                                                = try(each.value.data.radius_load_balancing_policy, local.defaults.meraki.networks.networks_wireless_ssids.radius_load_balancing_policy, null)
  radius_accounting_enabled                                                   = try(each.value.data.radius_accounting_enabled, local.defaults.meraki.networks.networks_wireless_ssids.radius_accounting_enabled, null)
  radius_accounting_servers                                                   = try(each.value.data.radius_accounting_servers, local.defaults.meraki.networks.networks_wireless_ssids.radius_accounting_servers, null)
  radius_accounting_interim_interval                                          = try(each.value.data.radius_accounting_interim_interval, local.defaults.meraki.networks.networks_wireless_ssids.radius_accounting_interim_interval, null)
  radius_attribute_for_group_policies                                         = try(each.value.data.radius_attribute_for_group_policies, local.defaults.meraki.networks.networks_wireless_ssids.radius_attribute_for_group_policies, null)
  ip_assignment_mode                                                          = try(each.value.data.ip_assignment_mode, local.defaults.meraki.networks.networks_wireless_ssids.ip_assignment_mode, null)
  use_vlan_tagging                                                            = try(each.value.data.use_vlan_tagging, local.defaults.meraki.networks.networks_wireless_ssids.use_vlan_tagging, null)
  concentrator_network_id                                                     = try(each.value.data.concentrator_network_id, local.defaults.meraki.networks.networks_wireless_ssids.concentrator_network_id, null)
  secondary_concentrator_network_id                                           = try(each.value.data.secondary_concentrator_network_id, local.defaults.meraki.networks.networks_wireless_ssids.secondary_concentrator_network_id, null)
  disassociate_clients_on_vpn_failover                                        = try(each.value.data.disassociate_clients_on_vpn_failover, local.defaults.meraki.networks.networks_wireless_ssids.disassociate_clients_on_vpn_failover, null)
  vlan_id                                                                     = try(each.value.data.vlan_id, local.defaults.meraki.networks.networks_wireless_ssids.vlan_id, null)
  default_vlan_id                                                             = try(each.value.data.default_vlan_id, local.defaults.meraki.networks.networks_wireless_ssids.default_vlan_id, null)
  ap_tags_and_vlan_ids                                                        = try(each.value.data.ap_tags_and_vlan_ids, local.defaults.meraki.networks.networks_wireless_ssids.ap_tags_and_vlan_ids, null)
  walled_garden_enabled                                                       = try(each.value.data.walled_garden_enabled, local.defaults.meraki.networks.networks_wireless_ssids.walled_garden_enabled, null)
  walled_garden_ranges                                                        = try(each.value.data.walled_garden_ranges, local.defaults.meraki.networks.networks_wireless_ssids.walled_garden_ranges, null)
  gre_concentrator_host                                                       = try(each.value.data.gre.concentrator.host, local.defaults.meraki.networks.networks_wireless_ssids.gre.concentrator.host, null)
  gre_key                                                                     = try(each.value.data.gre.key, local.defaults.meraki.networks.networks_wireless_ssids.gre.key, null)
  radius_override                                                             = try(each.value.data.radius_override, local.defaults.meraki.networks.networks_wireless_ssids.radius_override, null)
  radius_guest_vlan_enabled                                                   = try(each.value.data.radius_guest_vlan_enabled, local.defaults.meraki.networks.networks_wireless_ssids.radius_guest_vlan_enabled, null)
  radius_guest_vlan_id                                                        = try(each.value.data.radius_guest_vlan_id, local.defaults.meraki.networks.networks_wireless_ssids.radius_guest_vlan_id, null)
  min_bitrate                                                                 = try(each.value.data.min_bitrate, local.defaults.meraki.networks.networks_wireless_ssids.min_bitrate, null)
  band_selection                                                              = try(each.value.data.band_selection, local.defaults.meraki.networks.networks_wireless_ssids.band_selection, null)
  per_client_bandwidth_limit_up                                               = try(each.value.data.per_client_bandwidth_limit_up, local.defaults.meraki.networks.networks_wireless_ssids.per_client_bandwidth_limit_up, null)
  per_client_bandwidth_limit_down                                             = try(each.value.data.per_client_bandwidth_limit_down, local.defaults.meraki.networks.networks_wireless_ssids.per_client_bandwidth_limit_down, null)
  per_ssid_bandwidth_limit_up                                                 = try(each.value.data.per_ssid_bandwidth_limit_up, local.defaults.meraki.networks.networks_wireless_ssids.per_ssid_bandwidth_limit_up, null)
  per_ssid_bandwidth_limit_down                                               = try(each.value.data.per_ssid_bandwidth_limit_down, local.defaults.meraki.networks.networks_wireless_ssids.per_ssid_bandwidth_limit_down, null)
  lan_isolation_enabled                                                       = try(each.value.data.lan_isolation_enabled, local.defaults.meraki.networks.networks_wireless_ssids.lan_isolation_enabled, null)
  visible                                                                     = try(each.value.data.visible, local.defaults.meraki.networks.networks_wireless_ssids.visible, null)
  available_on_all_aps                                                        = try(each.value.data.available_on_all_aps, local.defaults.meraki.networks.networks_wireless_ssids.available_on_all_aps, null)
  availability_tags                                                           = try(each.value.data.availability_tags, local.defaults.meraki.networks.networks_wireless_ssids.availability_tags, null)
  mandatory_dhcp_enabled                                                      = try(each.value.data.mandatory_dhcp_enabled, local.defaults.meraki.networks.networks_wireless_ssids.mandatory_dhcp_enabled, null)
  adult_content_filtering_enabled                                             = try(each.value.data.adult_content_filtering_enabled, local.defaults.meraki.networks.networks_wireless_ssids.adult_content_filtering_enabled, null)
  dns_rewrite_enabled                                                         = try(each.value.data.dns_rewrite.enabled, local.defaults.meraki.networks.networks_wireless_ssids.dns_rewrite.enabled, null)
  dns_rewrite_dns_custom_nameservers                                          = try(each.value.data.dns_rewrite.dns_custom_nameservers, local.defaults.meraki.networks.networks_wireless_ssids.dns_rewrite.dns_custom_nameservers, null)
  speed_burst_enabled                                                         = try(each.value.data.speed_burst.enabled, local.defaults.meraki.networks.networks_wireless_ssids.speed_burst.enabled, null)
  named_vlans_tagging_enabled                                                 = try(each.value.data.named_vlans.tagging.enabled, local.defaults.meraki.networks.networks_wireless_ssids.named_vlans.tagging.enabled, null)
  named_vlans_tagging_default_vlan_name                                       = try(each.value.data.named_vlans.tagging.default_vlan_name, local.defaults.meraki.networks.networks_wireless_ssids.named_vlans.tagging.default_vlan_name, null)
  named_vlans_tagging_by_ap_tags                                              = try(each.value.data.named_vlans.tagging.by_ap_tags, local.defaults.meraki.networks.networks_wireless_ssids.named_vlans.tagging.by_ap_tags, null)
  named_vlans_radius_guest_vlan_enabled                                       = try(each.value.data.named_vlans.radius.guest_vlan.enabled, local.defaults.meraki.networks.networks_wireless_ssids.named_vlans.radius.guest_vlan.enabled, null)
  named_vlans_radius_guest_vlan_name                                          = try(each.value.data.named_vlans.radius.guest_vlan.name, local.defaults.meraki.networks.networks_wireless_ssids.named_vlans.radius.guest_vlan.name, null)
}
locals {
  networks_wireless_ssid_eap_overrides = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for i, wireless_ssid in try(network.wireless_ssids, []) : {
            network_id   = meraki_network.network["${domain.name}/${organization.name}/${network.name}"].id
            ssid_name    = wireless_ssid.name
            eap_override = try(wireless_ssid.eap_override, null)
            number       = i
          } if try(wireless_ssid.eap_override, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}
resource "meraki_wireless_ssid_eap_override" "net_wireless_ssid_eap_override" {
  for_each                = { for i, v in local.networks_wireless_ssid_eap_overrides : i => v }
  network_id              = each.value.network_id
  number                  = each.value.number
  max_retries             = try(each.value.eap_override.max_retries, 5)
  timeout                 = try(each.value.eap_override.timeout, 5)
  eapol_key_retries       = try(each.value.eap_override.eapol_key.retries, 3)
  eapol_key_timeout_in_ms = try(each.value.eap_override.eapol_key.timeout_in_ms, 10000)
  identity_retries        = try(each.value.eap_override.identity.retries, 3)
  identity_timeout        = try(each.value.eap_override.identity.timeout, 10)
  depends_on = [
    meraki_wireless_ssid.net_wireless_ssids
  ]
}
