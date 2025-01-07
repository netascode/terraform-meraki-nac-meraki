
//TODO: @jon-humphries need to ensure that this data model is correct as its currently not validating

# Apply the Meraki Wireless RF Profiles
locals {
  networks_wireless_rf_profiles = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for wireless_rf_profile in try(network.wireless.rf_profiles, []) : {
            network_id = meraki_network.network["${organization.name}/${network.name}"].id

            data = try(wireless_rf_profile, null)
          } if try(network.wireless.rf_profiles, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_wireless_rf_profile" "net_wireless_rf_profiles" {
  for_each   = { for i, v in local.networks_wireless_rf_profiles : i => v }
  network_id = each.value.network_id

  name                                       = try(each.value.data.name, local.defaults.meraki.networks.networks_wireless.rf_profiles.name, null)
  client_balancing_enabled                   = try(each.value.data.client_balancing, local.defaults.meraki.networks.networks_wireless.rf_profiles.client_balancing, null)
  min_bitrate_type                           = try(each.value.data.min_bitrate_type, local.defaults.meraki.networks.networks_wireless.rf_profiles.min_bitrate_type, null)
  band_selection_type                        = try(each.value.data.band_selection_type, local.defaults.meraki.networks.networks_wireless.rf_profiles.band_selection_type, null)
  ap_band_settings_band_operation_mode       = try(each.value.data.ap_band_settings.band_operation_mode, local.defaults.meraki.networks.networks_wireless.rf_profiles.ap_band_settings.band_operation_mode, null)
  ap_band_settings_bands_enabled             = try(each.value.data.ap_band_settings.bands.enabled, local.defaults.meraki.networks.networks_wireless.rf_profiles.ap_band_settings.bands.enabled, null)
  ap_band_settings_band_steering_enabled     = try(each.value.data.ap_band_settings.band_steering, local.defaults.meraki.networks.networks_wireless.rf_profiles.ap_band_settings.band_steering, null)
  two_four_ghz_settings_max_power            = try(each.value.data.two_four_ghz_settings.max_power, local.defaults.meraki.networks.networks_wireless.rf_profiles.two_four_ghz_settings.max_power, null)
  two_four_ghz_settings_min_power            = try(each.value.data.two_four_ghz_settings.min_power, local.defaults.meraki.networks.networks_wireless.rf_profiles.two_four_ghz_settings.min_power, null)
  two_four_ghz_settings_min_bitrate          = try(each.value.data.two_four_ghz_settings.min_bitrate, local.defaults.meraki.networks.networks_wireless.rf_profiles.two_four_ghz_settings.min_bitrate, null)
  two_four_ghz_settings_valid_auto_channels  = try(each.value.data.two_four_ghz_settings.valid_auto_channels, local.defaults.meraki.networks.networks_wireless.rf_profiles.two_four_ghz_settings.valid_auto_channels, null)
  two_four_ghz_settings_ax_enabled           = try(each.value.data.two_four_ghz_settings.ax, local.defaults.meraki.networks.networks_wireless.rf_profiles.two_four_ghz_settings.ax, null)
  two_four_ghz_settings_rxsop                = try(each.value.data.two_four_ghz_settings.rxsop, local.defaults.meraki.networks.networks_wireless.rf_profiles.two_four_ghz_settings.rxsop, null)
  five_ghz_settings_max_power                = try(each.value.data.five_ghz_settings.max_power, local.defaults.meraki.networks.networks_wireless.rf_profiles.five_ghz_settings.max_power, null)
  five_ghz_settings_min_power                = try(each.value.data.five_ghz_settings.min_power, local.defaults.meraki.networks.networks_wireless.rf_profiles.five_ghz_settings.min_power, null)
  five_ghz_settings_min_bitrate              = try(each.value.data.five_ghz_settings.min_bitrate, local.defaults.meraki.networks.networks_wireless.rf_profiles.five_ghz_settings.min_bitrate, null)
  five_ghz_settings_valid_auto_channels      = try(each.value.data.five_ghz_settings.valid_auto_channels, local.defaults.meraki.networks.networks_wireless.rf_profiles.five_ghz_settings.valid_auto_channels, null)
  five_ghz_settings_channel_width            = try(each.value.data.five_ghz_settings.channel_width, local.defaults.meraki.networks.networks_wireless.rf_profiles.five_ghz_settings.channel_width, null)
  five_ghz_settings_rxsop                    = try(each.value.data.five_ghz_settings.rxsop, local.defaults.meraki.networks.networks_wireless.rf_profiles.five_ghz_settings.rxsop, null)
  six_ghz_settings_max_power                 = try(each.value.data.six_ghz_settings.max_power, local.defaults.meraki.networks.networks_wireless.rf_profiles.six_ghz_settings.max_power, null)
  six_ghz_settings_min_power                 = try(each.value.data.six_ghz_settings.min_power, local.defaults.meraki.networks.networks_wireless.rf_profiles.six_ghz_settings.min_power, null)
  six_ghz_settings_min_bitrate               = try(each.value.data.six_ghz_settings.min_bitrate, local.defaults.meraki.networks.networks_wireless.rf_profiles.six_ghz_settings.min_bitrate, null)
  six_ghz_settings_valid_auto_channels       = try(each.value.data.six_ghz_settings.valid_auto_channels, local.defaults.meraki.networks.networks_wireless.rf_profiles.six_ghz_settings.valid_auto_channels, null)
  six_ghz_settings_channel_width             = try(each.value.data.six_ghz_settings.channel_width, local.defaults.meraki.networks.networks_wireless.rf_profiles.six_ghz_settings.channel_width, null)
  six_ghz_settings_rxsop                     = try(each.value.data.six_ghz_settings.rxsop, local.defaults.meraki.networks.networks_wireless.rf_profiles.six_ghz_settings.rxsop, null)
  transmission_enabled                       = try(each.value.data.transmission.enabled, local.defaults.meraki.networks.networks_wireless.rf_profiles.transmission.enabled, null)
  per_ssid_settings_0_min_bitrate            = try(each.value.data.per_ssid_settings[0].min_bitrate, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[0].min_bitrate, null)
  per_ssid_settings_0_band_operation_mode    = try(each.value.data.per_ssid_settings[0].band_operation_mode, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[0].band_operation_mode, null)
  per_ssid_settings_0_bands_enabled          = try(each.value.data.per_ssid_settings[0].bands.enabled, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[0].bands.enabled, null)
  per_ssid_settings_0_band_steering_enabled  = try(each.value.data.per_ssid_settings[0].band_steering, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[0].band_steering, null)
  per_ssid_settings_1_min_bitrate            = try(each.value.data.per_ssid_settings[1].min_bitrate, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[1].min_bitrate, null)
  per_ssid_settings_1_band_operation_mode    = try(each.value.data.per_ssid_settings[1].band_operation_mode, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[1].band_operation_mode, null)
  per_ssid_settings_1_bands_enabled          = try(each.value.data.per_ssid_settings[1].bands.enabled, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[1].bands.enabled, null)
  per_ssid_settings_1_band_steering_enabled  = try(each.value.data.per_ssid_settings[1].band_steering, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[1].band_steering, null)
  per_ssid_settings_2_min_bitrate            = try(each.value.data.per_ssid_settings[2].min_bitrate, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[2].min_bitrate, null)
  per_ssid_settings_2_band_operation_mode    = try(each.value.data.per_ssid_settings[2].band_operation_mode, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[2].band_operation_mode, null)
  per_ssid_settings_2_bands_enabled          = try(each.value.data.per_ssid_settings[2].bands.enabled, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[2].bands.enabled, null)
  per_ssid_settings_2_band_steering_enabled  = try(each.value.data.per_ssid_settings[2].band_steering, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[2].band_steering, null)
  per_ssid_settings_3_min_bitrate            = try(each.value.data.per_ssid_settings[3].min_bitrate, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[3].min_bitrate, null)
  per_ssid_settings_3_band_operation_mode    = try(each.value.data.per_ssid_settings[3].band_operation_mode, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[3].band_operation_mode, null)
  per_ssid_settings_3_bands_enabled          = try(each.value.data.per_ssid_settings[3].bands.enabled, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[3].bands.enabled, null)
  per_ssid_settings_3_band_steering_enabled  = try(each.value.data.per_ssid_settings[3].band_steering, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[3].band_steering, null)
  per_ssid_settings_4_min_bitrate            = try(each.value.data.per_ssid_settings[4].min_bitrate, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[4].min_bitrate, null)
  per_ssid_settings_4_band_operation_mode    = try(each.value.data.per_ssid_settings[4].band_operation_mode, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[4].band_operation_mode, null)
  per_ssid_settings_4_bands_enabled          = try(each.value.data.per_ssid_settings[4].bands.enabled, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[4].bands.enabled, null)
  per_ssid_settings_4_band_steering_enabled  = try(each.value.data.per_ssid_settings[4].band_steering, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[4].band_steering, null)
  per_ssid_settings_5_min_bitrate            = try(each.value.data.per_ssid_settings[5].min_bitrate, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[5].min_bitrate, null)
  per_ssid_settings_5_band_operation_mode    = try(each.value.data.per_ssid_settings[5].band_operation_mode, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[5].band_operation_mode, null)
  per_ssid_settings_5_bands_enabled          = try(each.value.data.per_ssid_settings[5].bands.enabled, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[5].bands.enabled, null)
  per_ssid_settings_5_band_steering_enabled  = try(each.value.data.per_ssid_settings[5].band_steering, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[5].band_steering, null)
  per_ssid_settings_6_min_bitrate            = try(each.value.data.per_ssid_settings[6].min_bitrate, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[6].min_bitrate, null)
  per_ssid_settings_6_band_operation_mode    = try(each.value.data.per_ssid_settings[6].band_operation_mode, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[6].band_operation_mode, null)
  per_ssid_settings_6_bands_enabled          = try(each.value.data.per_ssid_settings[6].bands.enabled, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[6].bands.enabled, null)
  per_ssid_settings_6_band_steering_enabled  = try(each.value.data.per_ssid_settings[6].band_steering, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[6].band_steering, null)
  per_ssid_settings_7_min_bitrate            = try(each.value.data.per_ssid_settings[7].min_bitrate, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[7].min_bitrate, null)
  per_ssid_settings_7_band_operation_mode    = try(each.value.data.per_ssid_settings[7].band_operation_mode, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[7].band_operation_mode, null)
  per_ssid_settings_7_bands_enabled          = try(each.value.data.per_ssid_settings[7].bands.enabled, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[7].bands.enabled, null)
  per_ssid_settings_7_band_steering_enabled  = try(each.value.data.per_ssid_settings[7].band_steering, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[7].band_steering, null)
  per_ssid_settings_8_min_bitrate            = try(each.value.data.per_ssid_settings[8].min_bitrate, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[8].min_bitrate, null)
  per_ssid_settings_8_band_operation_mode    = try(each.value.data.per_ssid_settings[8].band_operation_mode, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[8].band_operation_mode, null)
  per_ssid_settings_8_bands_enabled          = try(each.value.data.per_ssid_settings[8].bands.enabled, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[8].bands.enabled, null)
  per_ssid_settings_8_band_steering_enabled  = try(each.value.data.per_ssid_settings[8].band_steering, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[8].band_steering, null)
  per_ssid_settings_9_min_bitrate            = try(each.value.data.per_ssid_settings[9].min_bitrate, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[9].min_bitrate, null)
  per_ssid_settings_9_band_operation_mode    = try(each.value.data.per_ssid_settings[9].band_operation_mode, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[9].band_operation_mode, null)
  per_ssid_settings_9_bands_enabled          = try(each.value.data.per_ssid_settings[9].bands.enabled, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[9].bands.enabled, null)
  per_ssid_settings_9_band_steering_enabled  = try(each.value.data.per_ssid_settings[9].band_steering, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[9].band_steering, null)
  per_ssid_settings_10_min_bitrate           = try(each.value.data.per_ssid_settings[10].min_bitrate, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[10].min_bitrate, null)
  per_ssid_settings_10_band_operation_mode   = try(each.value.data.per_ssid_settings[10].band_operation_mode, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[10].band_operation_mode, null)
  per_ssid_settings_10_bands_enabled         = try(each.value.data.per_ssid_settings[10].bands.enabled, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[10].bands.enabled, null)
  per_ssid_settings_10_band_steering_enabled = try(each.value.data.per_ssid_settings[10].band_steering, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[10].band_steering, null)
  per_ssid_settings_11_min_bitrate           = try(each.value.data.per_ssid_settings[11].min_bitrate, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[11].min_bitrate, null)
  per_ssid_settings_11_band_operation_mode   = try(each.value.data.per_ssid_settings[11].band_operation_mode, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[11].band_operation_mode, null)
  per_ssid_settings_11_bands_enabled         = try(each.value.data.per_ssid_settings[11].bands.enabled, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[11].bands.enabled, null)
  per_ssid_settings_11_band_steering_enabled = try(each.value.data.per_ssid_settings[11].band_steering, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[11].band_steering, null)
  per_ssid_settings_12_min_bitrate           = try(each.value.data.per_ssid_settings[12].min_bitrate, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[12].min_bitrate, null)
  per_ssid_settings_12_band_operation_mode   = try(each.value.data.per_ssid_settings[12].band_operation_mode, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[12].band_operation_mode, null)
  per_ssid_settings_12_bands_enabled         = try(each.value.data.per_ssid_settings[12].bands.enabled, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[12].bands.enabled, null)
  per_ssid_settings_12_band_steering_enabled = try(each.value.data.per_ssid_settings[12].band_steering, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[12].band_steering, null)
  per_ssid_settings_13_min_bitrate           = try(each.value.data.per_ssid_settings[13].min_bitrate, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[13].min_bitrate, null)
  per_ssid_settings_13_band_operation_mode   = try(each.value.data.per_ssid_settings[13].band_operation_mode, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[13].band_operation_mode, null)
  per_ssid_settings_13_bands_enabled         = try(each.value.data.per_ssid_settings[13].bands.enabled, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[13].bands.enabled, null)
  per_ssid_settings_13_band_steering_enabled = try(each.value.data.per_ssid_settings[13].band_steering, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[13].band_steering, null)
  per_ssid_settings_14_min_bitrate           = try(each.value.data.per_ssid_settings[14].min_bitrate, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[14].min_bitrate, null)
  per_ssid_settings_14_band_operation_mode   = try(each.value.data.per_ssid_settings[14].band_operation_mode, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[14].band_operation_mode, null)
  per_ssid_settings_14_bands_enabled         = try(each.value.data.per_ssid_settings[14].bands.enabled, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[14].bands.enabled, null)
  per_ssid_settings_14_band_steering_enabled = try(each.value.data.per_ssid_settings[14].band_steering, local.defaults.meraki.networks.networks_wireless.rf_profiles.per_ssid_settings[14].band_steering_enabled, null)
  flex_radios_by_model                       = try(each.value.data.flex_radios.by_model, local.defaults.meraki.networks.networks_wireless.rf_profiles.flex_radios.by_model, null)

}
# Apply the Wireless Settings
locals {
  networks_wireless_settings = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id

          data = try(network.wireless.settings, null)
        } if try(network.wireless.settings, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_wireless_settings" "net_wireless_settings" {
  for_each   = { for i, v in local.networks_wireless_settings : i => v }
  network_id = each.value.network_id

  meshing_enabled                           = try(each.value.data.meshing, local.defaults.meraki.networks.networks_wireless_settings.meshing_enabled, null)
  ipv6_bridge_enabled                       = try(each.value.data.ipv6_bridge, local.defaults.meraki.networks.networks_wireless_settings.ipv6_bridge_enabled, null)
  location_analytics_enabled                = try(each.value.data.location_analytics, local.defaults.meraki.networks.networks_wireless_settings.location_analytics_enabled, null)
  upgrade_strategy                          = try(each.value.data.upgrade_strategy, local.defaults.meraki.networks.networks_wireless_settings.upgrade_strategy, null)
  led_lights_on                             = try(each.value.data.led_lights_on, local.defaults.meraki.networks.networks_wireless_settings.led_lights_on, null)
  named_vlans_pool_dhcp_monitoring_enabled  = try(each.value.data.named_vlans.pool_dhcp_monitoring.enabled, local.defaults.meraki.networks.networks_wireless_settings.named_vlans.pool_dhcp_monitoring.enabled, null)
  named_vlans_pool_dhcp_monitoring_duration = try(each.value.data.named_vlans.pool_dhcp_monitoring.duration, local.defaults.meraki.networks.networks_wireless_settings.named_vlans.pool_dhcp_monitoring.duration, null)

}
# Apply the Wireless SSIDs
locals {
  wireless_ssids_numbers_list = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for i, wireless_ssid in try(network.wireless_ssids, []) : {
            key    = format("${organization.name}/${network.name}/wireless_ssid/${wireless_ssid.name}")
            number = i
          } if try(network.wireless_ssids, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
  wireless_ssids_map = { for w in local.wireless_ssids_numbers_list : w.key => w.number }
  networks_wireless_ssids = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for i, wireless_ssid in try(network.wireless_ssids, []) : {
            key        = format("${organization.name}/${network.name}/wireless_ssid/${wireless_ssid.name}") # Include the key
            network_id = meraki_network.network["${organization.name}/${network.name}"].id
            number     = i
            data       = try(wireless_ssid, null)
          } if try(network.wireless_ssids, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}
resource "meraki_wireless_ssid" "net_wireless_ssids" {
  for_each   = { for v in local.networks_wireless_ssids : v.key => v }
  network_id = each.value.network_id
  number     = each.value.data.ssid_number

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
  local_radius_password_authentication_enabled                                = try(each.value.data.local_radius.password_authentication.enabled, local.defaults.meraki.networks.networks_wireless_ssids.local_radius.password_authentication, null)
  local_radius_certificate_authentication_enabled                             = try(each.value.data.local_radius.certificate_authentication.enabled, local.defaults.meraki.networks.networks_wireless_ssids.local_radius.certificate_authentication, null)
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
  radius_proxy_enabled                                                        = try(each.value.data.radius_proxy_enabled, local.defaults.meraki.networks.networks_wireless_ssids.radius_proxy, null)
  radius_testing_enabled                                                      = try(each.value.data.radius_testing_enabled, local.defaults.meraki.networks.networks_wireless_ssids.radius_testing, null)
  radius_called_station_id                                                    = try(each.value.data.radius_called_station_id, local.defaults.meraki.networks.networks_wireless_ssids.radius_called_station_id, null)
  radius_authentication_nas_id                                                = try(each.value.data.radius_authentication_nas_id, local.defaults.meraki.networks.networks_wireless_ssids.radius_authentication_nas_id, null)
  radius_server_timeout                                                       = try(each.value.data.radius_server_timeout, local.defaults.meraki.networks.networks_wireless_ssids.radius_server_timeout, null)
  radius_server_attempts_limit                                                = try(each.value.data.radius_server_attempts_limit, local.defaults.meraki.networks.networks_wireless_ssids.radius_server_attempts_limit, null)
  radius_fallback_enabled                                                     = try(each.value.data.radius_fallback, local.defaults.meraki.networks.networks_wireless_ssids.radius_fallback, null)
  radius_coa_enabled                                                          = try(each.value.data.radius_coa, local.defaults.meraki.networks.networks_wireless_ssids.radius_coa, null)
  radius_failover_policy                                                      = try(each.value.data.radius_failover_policy, local.defaults.meraki.networks.networks_wireless_ssids.radius_failover_policy, null)
  radius_load_balancing_policy                                                = try(each.value.data.radius_load_balancing_policy, local.defaults.meraki.networks.networks_wireless_ssids.radius_load_balancing_policy, null)
  radius_accounting_enabled                                                   = try(each.value.data.radius_accounting, local.defaults.meraki.networks.networks_wireless_ssids.radius_accounting, null)
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
  walled_garden_enabled                                                       = try(each.value.data.walled_garden, local.defaults.meraki.networks.networks_wireless_ssids.walled_garden, null)
  walled_garden_ranges                                                        = try(each.value.data.walled_garden_ranges, local.defaults.meraki.networks.networks_wireless_ssids.walled_garden_ranges, null)
  gre_concentrator_host                                                       = try(each.value.data.gre.concentrator.host, local.defaults.meraki.networks.networks_wireless_ssids.gre.concentrator.host, null)
  gre_key                                                                     = try(each.value.data.gre.key, local.defaults.meraki.networks.networks_wireless_ssids.gre.key, null)
  radius_override                                                             = try(each.value.data.radius_override, local.defaults.meraki.networks.networks_wireless_ssids.radius_override, null)
  radius_guest_vlan_enabled                                                   = try(each.value.data.radius_guest_vlan, local.defaults.meraki.networks.networks_wireless_ssids.radius_guest_vlan, null)
  radius_guest_vlan_id                                                        = try(each.value.data.radius_guest_vlan_id, local.defaults.meraki.networks.networks_wireless_ssids.radius_guest_vlan_id, null)
  min_bitrate                                                                 = try(each.value.data.min_bitrate, local.defaults.meraki.networks.networks_wireless_ssids.min_bitrate, null)
  band_selection                                                              = try(each.value.data.band_selection, local.defaults.meraki.networks.networks_wireless_ssids.band_selection, null)
  per_client_bandwidth_limit_up                                               = try(each.value.data.per_client_bandwidth_limit_up, local.defaults.meraki.networks.networks_wireless_ssids.per_client_bandwidth_limit_up, null)
  per_client_bandwidth_limit_down                                             = try(each.value.data.per_client_bandwidth_limit_down, local.defaults.meraki.networks.networks_wireless_ssids.per_client_bandwidth_limit_down, null)
  per_ssid_bandwidth_limit_up                                                 = try(each.value.data.per_ssid_bandwidth_limit_up, local.defaults.meraki.networks.networks_wireless_ssids.per_ssid_bandwidth_limit_up, null)
  per_ssid_bandwidth_limit_down                                               = try(each.value.data.per_ssid_bandwidth_limit_down, local.defaults.meraki.networks.networks_wireless_ssids.per_ssid_bandwidth_limit_down, null)
  lan_isolation_enabled                                                       = try(each.value.data.lan_isolation, local.defaults.meraki.networks.networks_wireless_ssids.lan_isolation, null)
  visible                                                                     = try(each.value.data.visible, local.defaults.meraki.networks.networks_wireless_ssids.visible, null)
  available_on_all_aps                                                        = try(each.value.data.available_on_all_aps, local.defaults.meraki.networks.networks_wireless_ssids.available_on_all_aps, null)
  availability_tags                                                           = try(each.value.data.availability_tags, local.defaults.meraki.networks.networks_wireless_ssids.availability_tags, null)
  mandatory_dhcp_enabled                                                      = try(each.value.data.mandatory_dhcp, local.defaults.meraki.networks.networks_wireless_ssids.mandatory_dhcp, null)
  adult_content_filtering_enabled                                             = try(each.value.data.adult_content_filtering, local.defaults.meraki.networks.networks_wireless_ssids.adult_content_filtering, null)
  dns_rewrite_enabled                                                         = try(each.value.data.dns_rewrite, local.defaults.meraki.networks.networks_wireless_ssids.dns_rewrite, null)
  dns_rewrite_dns_custom_nameservers                                          = try(each.value.data.dns_rewrite.dns_custom_nameservers, local.defaults.meraki.networks.networks_wireless_ssids.dns_rewrite.dns_custom_nameservers, null)
  speed_burst_enabled                                                         = try(each.value.data.speed_burst, local.defaults.meraki.networks.networks_wireless_ssids.speed_burst, null)
  named_vlans_tagging_enabled                                                 = try(each.value.data.named_vlans.tagging, local.defaults.meraki.networks.networks_wireless_ssids.named_vlans.tagging, null)
  named_vlans_tagging_default_vlan_name                                       = try(each.value.data.named_vlans.tagging.default_vlan_name, local.defaults.meraki.networks.networks_wireless_ssids.named_vlans.tagging.default_vlan_name, null)
  named_vlans_tagging_by_ap_tags                                              = try(each.value.data.named_vlans.tagging.by_ap_tags, local.defaults.meraki.networks.networks_wireless_ssids.named_vlans.tagging.by_ap_tags, null)
  named_vlans_radius_guest_vlan_enabled                                       = try(each.value.data.named_vlans.radius.guest_vlan, local.defaults.meraki.networks.networks_wireless_ssids.named_vlans.radius.guest_vlan, null)
  named_vlans_radius_guest_vlan_name                                          = try(each.value.data.named_vlans.radius.guest_vlan.name, local.defaults.meraki.networks.networks_wireless_ssids.named_vlans.radius.guest_vlan.name, null)
}
locals {
  networks_wireless_ssid_eap_overrides = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for wireless_ssid in try(network.wireless_ssids, []) : {
            network_id   = meraki_network.network["${organization.name}/${network.name}"].id
            eap_override = try(wireless_ssid.eap_override, null)
            number       = local.wireless_ssids_map["${organization.name}/${network.name}/wireless_ssid/${wireless_ssid.name}"]
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

locals {
  networks_wireless_ssids_device_type_group_policies = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for wireless_ssid in try(network.wireless_ssids, []) : {
            network_id = meraki_network.network["${organization.name}/${network.name}"].id
            number     = local.wireless_ssids_map["${organization.name}/${network.name}/wireless_ssid/${wireless_ssid.name}"]
            data       = try(wireless_ssid.device_type_group_policies, null)
          } if try(wireless_ssid.device_type_group_policies, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_wireless_ssid_device_type_group_policies" "net_wireless_ssids_device_type_group_policies" {
  for_each   = { for i, v in local.networks_wireless_ssids_device_type_group_policies : i => v }
  network_id = each.value.network_id
  number     = each.value.number

  enabled              = try(each.value.data.enabled, local.defaults.meraki.networks.networks_wireless_ssids_device_type_group_policies.enabled, null)
  device_type_policies = try(each.value.data.device_type_policies, local.defaults.meraki.networks.networks_wireless_ssids_device_type_group_policies.device_type_policies, null)

  depends_on = [
    meraki_wireless_ssid.net_wireless_ssids
  ]

}

locals {
  networks_wireless_ssids_firewall_l3_firewall_rules = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for wireless_ssid in try(network.wireless_ssids, []) : {
            network_id = meraki_network.network["${organization.name}/${network.name}"].id
            number     = local.wireless_ssids_map["${organization.name}/${network.name}/wireless_ssid/${wireless_ssid.name}"]
            data       = try(wireless_ssid.firewall_l3_firewall_rules, null)
          } if try(wireless_ssid.firewall_l3_firewall_rules, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_wireless_ssid_l3_firewall_rules" "net_wireless_ssids_l3_firewall_rules" {
  for_each   = { for i, v in local.networks_wireless_ssids_firewall_l3_firewall_rules : i => v }
  network_id = each.value.network_id
  number     = each.value.number

  rules            = try(each.value.data.rules, local.defaults.meraki.networks.networks_wireless_ssids_firewall_l3_firewall_rules.rules, null)
  allow_lan_access = try(each.value.data.allow_lan_access, local.defaults.meraki.networks.networks_wireless_ssids_firewall_l3_firewall_rules.allow_lan_access, null)
  depends_on = [
    meraki_wireless_ssid.net_wireless_ssids
  ]
}


locals {
  networks_wireless_ssids_hotspot20 = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for wireless_ssid in try(network.wireless_ssids, []) : {
            network_id = meraki_network.network["${organization.name}/${network.name}"].id
            number     = local.wireless_ssids_map["${organization.name}/${network.name}/wireless_ssid/${wireless_ssid.name}"]
            data       = try(wireless_ssid.hotspot20, null)
          } if try(wireless_ssid.hotspot20, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_wireless_ssid_hotspot_20" "net_wireless_ssids_hotspot20" {
  for_each   = { for i, v in local.networks_wireless_ssids_hotspot20 : i => v }
  network_id = each.value.network_id
  number     = each.value.number

  enabled             = try(each.value.data.enabled, local.defaults.meraki.networks.networks_wireless_ssids_hotspot20.enabled, null)
  operator_name       = try(each.value.data.operator.name, local.defaults.meraki.networks.networks_wireless_ssids_hotspot20.operator.name, null)
  venue_name          = try(each.value.data.venue.name, local.defaults.meraki.networks.networks_wireless_ssids_hotspot20.venue.name, null)
  venue_type          = try(each.value.data.venue.type, local.defaults.meraki.networks.networks_wireless_ssids_hotspot20.venue.type, null)
  network_access_type = try(each.value.data.network_access_type, local.defaults.meraki.networks.networks_wireless_ssids_hotspot20.network_access_type, null)
  domains             = try(each.value.data.domains, local.defaults.meraki.networks.networks_wireless_ssids_hotspot20.domains, null)
  roam_consort_ois    = try(each.value.data.roam_consort_ois, local.defaults.meraki.networks.networks_wireless_ssids_hotspot20.roam_consort_ois, null)
  mcc_mncs            = try(each.value.data.mcc_mncs, local.defaults.meraki.networks.networks_wireless_ssids_hotspot20.mcc_mncs, null)
  nai_realms          = try(each.value.data.nai_realms, local.defaults.meraki.networks.networks_wireless_ssids_hotspot20.nai_realms, null)
  depends_on = [
    meraki_wireless_ssid.net_wireless_ssids
  ]
}

locals {
  networks_wireless_ssids_identity_psks = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for wireless_ssid in try(network.wireless_ssids, []) : [
            for identity_psk in try(wireless_ssid.identity_psks, []) : {
              network_id = meraki_network.network["${organization.name}/${network.name}"].id
              number     = local.wireless_ssids_map["${organization.name}/${network.name}/wireless_ssid/${wireless_ssid.name}"]
              data       = try(identity_psk, null)
            } if try(wireless_ssid.identity_psks, null) != null
          ] if try(network.wireless_ssids, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_wireless_ssid_identity_psk" "net_wireless_ssids_identity_psks" {
  for_each   = { for i, v in local.networks_wireless_ssids_identity_psks : i => v }
  network_id = each.value.network_id
  number     = each.value.number

  name            = try(each.value.data.name, local.defaults.meraki.networks.networks_wireless_ssids_identity_psks.name, null)
  passphrase      = try(each.value.data.passphrase, local.defaults.meraki.networks.networks_wireless_ssids_identity_psks.passphrase, null)
  group_policy_id = try(each.value.data.group_policy_id, local.defaults.meraki.networks.networks_wireless_ssids_identity_psks.group_policy_id, null)
  expires_at      = try(each.value.data.expires_at, local.defaults.meraki.networks.networks_wireless_ssids_identity_psks.expires_at, null)
  depends_on = [
    meraki_wireless_ssid.net_wireless_ssids
  ]
}


locals {
  networks_wireless_ssids_schedules = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for wireless_ssid in try(network.wireless_ssids, []) : {
            network_id = meraki_network.network["${organization.name}/${network.name}"].id
            number     = local.wireless_ssids_map["${organization.name}/${network.name}/wireless_ssid/${wireless_ssid.name}"]
            data       = try(wireless_ssid.schedules, null)
          } if try(wireless_ssid.schedules, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_wireless_ssid_schedules" "net_wireless_ssids_schedules" {
  for_each   = { for i, v in local.networks_wireless_ssids_schedules : i => v }
  network_id = each.value.network_id
  number     = each.value.number

  enabled           = try(each.value.data.enabled, local.defaults.meraki.networks.networks_wireless_ssids_schedules.enabled, null)
  ranges            = try(each.value.data.ranges, local.defaults.meraki.networks.networks_wireless_ssids_schedules.ranges, null)
  ranges_in_seconds = try(each.value.data.ranges_in_seconds, local.defaults.meraki.networks.networks_wireless_ssids_schedules.ranges_in_seconds, null)
  depends_on = [
    meraki_wireless_ssid.net_wireless_ssids
  ]
}

locals {
  networks_wireless_ssids_splash_settings = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for wireless_ssid in try(network.wireless_ssids, []) : {
            network_id = meraki_network.network["${organization.name}/${network.name}"].id
            number     = local.wireless_ssids_map["${organization.name}/${network.name}/wireless_ssid/${wireless_ssid.name}"]
            data       = try(wireless_ssid.splash_settings, null)
          } if try(wireless_ssid.splash_settings, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_wireless_ssid_splash_settings" "net_wireless_ssids_splash_settings" {
  for_each   = { for i, v in local.networks_wireless_ssids_splash_settings : i => v }
  network_id = each.value.network_id
  number     = each.value.number

  splash_url                                    = try(each.value.data.splash_url, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.splash_url, null)
  use_splash_url                                = try(each.value.data.use_splash_url, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.use_splash_url, null)
  splash_timeout                                = try(each.value.data.splash_timeout, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.splash_timeout, null)
  redirect_url                                  = try(each.value.data.redirect_url, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.redirect_url, null)
  use_redirect_url                              = try(each.value.data.use_redirect_url, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.use_redirect_url, null)
  welcome_message                               = try(each.value.data.welcome_message, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.welcome_message, null)
  theme_id                                      = try(each.value.data.theme_id, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.theme_id, null)
  splash_logo_md5                               = try(each.value.data.splash_logo.md5, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.splash_logo.md5, null)
  splash_logo_extension                         = try(each.value.data.splash_logo.extension, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.splash_logo.extension, null)
  splash_logo_image_format                      = try(each.value.data.splash_logo.image.format, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.splash_logo.image.format, null)
  splash_logo_image_contents                    = try(each.value.data.splash_logo.image.contents, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.splash_logo.image.contents, null)
  splash_image_md5                              = try(each.value.data.splash_image.md5, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.splash_image.md5, null)
  splash_image_extension                        = try(each.value.data.splash_image.extension, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.splash_image.extension, null)
  splash_image_image_format                     = try(each.value.data.splash_image.image.format, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.splash_image.image.format, null)
  splash_image_image_contents                   = try(each.value.data.splash_image.image.contents, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.splash_image.image.contents, null)
  splash_prepaid_front_md5                      = try(each.value.data.splash_prepaid_front.md5, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.splash_prepaid_front.md5, null)
  splash_prepaid_front_extension                = try(each.value.data.splash_prepaid_front.extension, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.splash_prepaid_front.extension, null)
  splash_prepaid_front_image_format             = try(each.value.data.splash_prepaid_front.image.format, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.splash_prepaid_front.image.format, null)
  splash_prepaid_front_image_contents           = try(each.value.data.splash_prepaid_front.image.contents, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.splash_prepaid_front.image.contents, null)
  block_all_traffic_before_sign_on              = try(each.value.data.block_all_traffic_before_sign_on, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.block_all_traffic_before_sign_on, null)
  controller_disconnection_behavior             = try(each.value.data.controller_disconnection_behavior, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.controller_disconnection_behavior, null)
  allow_simultaneous_logins                     = try(each.value.data.allow_simultaneous_logins, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.allow_simultaneous_logins, null)
  guest_sponsorship_duration_in_minutes         = try(each.value.data.guest_sponsorship.duration_in_minutes, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.guest_sponsorship.duration_in_minutes, null)
  guest_sponsorship_guest_can_request_timeframe = try(each.value.data.guest_sponsorship.guest_can_request_timeframe, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.guest_sponsorship.guest_can_request_timeframe, null)
  billing_free_access_enabled                   = try(each.value.data.billing.free_access.enabled, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.billing.free_access.enabled, null)
  billing_free_access_duration_in_minutes       = try(each.value.data.billing.free_access.duration_in_minutes, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.billing.free_access.duration_in_minutes, null)
  billing_prepaid_access_fast_login_enabled     = try(each.value.data.billing.prepaid_access_fast_login_enabled, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.billing.prepaid_access_fast_login_enabled, null)
  billing_reply_to_email_address                = try(each.value.data.billing.reply_to_email_address, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.billing.reply_to_email_address, null)
  sentry_enrollment_systems_manager_network_id  = try(each.value.data.sentry_enrollment.systems_manager_network.id, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.sentry_enrollment.systems_manager_network.id, null)
  sentry_enrollment_strength                    = try(each.value.data.sentry_enrollment.strength, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.sentry_enrollment.strength, null)
  sentry_enrollment_enforced_systems            = try(each.value.data.sentry_enrollment.enforced_systems, local.defaults.meraki.networks.networks_wireless_ssids_splash_settings.sentry_enrollment.enforced_systems, null)
  depends_on = [
    meraki_wireless_ssid.net_wireless_ssids
  ]
}


locals {
  networks_wireless_ssids_traffic_shaping_rules = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for wireless_ssid in try(network.wireless_ssids, []) : {
            network_id = meraki_network.network["${organization.name}/${network.name}"].id
            number     = local.wireless_ssids_map["${organization.name}/${network.name}/wireless_ssid/${wireless_ssid.name}"]
            data       = try(wireless_ssid.traffic_shaping_rules, null)
          } if try(wireless_ssid.traffic_shaping_rules, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_wireless_ssid_traffic_shaping_rules" "net_wireless_ssids_traffic_shaping_rules" {
  for_each   = { for i, v in local.networks_wireless_ssids_traffic_shaping_rules : i => v }
  network_id = each.value.network_id
  number     = each.value.number

  traffic_shaping_enabled = try(each.value.data.traffic_shaping_enabled, local.defaults.meraki.networks.networks_wireless_ssids_traffic_shaping_rules.traffic_shaping_enabled, null)
  default_rules_enabled   = try(each.value.data.default_rules_enabled, local.defaults.meraki.networks.networks_wireless_ssids_traffic_shaping_rules.default_rules_enabled, null)
  rules                   = try(each.value.data.rules, local.defaults.meraki.networks.networks_wireless_ssids_traffic_shaping_rules.rules, null)
  depends_on = [
    meraki_wireless_ssid.net_wireless_ssids
  ]
}


locals {
  networks_wireless_ssids_bonjour_forwarding = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for wireless_ssid in try(network.wireless_ssids, []) : {
            network_id = meraki_network.network["${organization.name}/${network.name}"].id
            number     = local.wireless_ssids_map["${organization.name}/${network.name}/wireless_ssid/${wireless_ssid.name}"]
            data       = try(wireless_ssid.bonjour_forwarding, null)
          } if try(wireless_ssid.bonjour_forwarding, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_wireless_ssid_bonjour_forwarding" "wireless_ssids_bonjour_forwarding" {
  for_each   = { for i, v in local.networks_wireless_ssids_bonjour_forwarding : i => v }
  network_id = each.value.network_id
  number     = each.value.number

  enabled           = try(each.value.data.enabled, local.defaults.meraki.networks.networks_wireless_ssids_bonjour_forwarding.enabled, null)
  rules             = try(each.value.data.rules, local.defaults.meraki.networks.networks_wireless_ssids_bonjour_forwarding.rules, null)
  exception_enabled = try(each.value.data.exception.enabled, local.defaults.meraki.networks.networks_wireless_ssids_bonjour_forwarding.exception.enabled, null)
  depends_on = [
    meraki_wireless_ssid.net_wireless_ssids
  ]
}

locals {
  networks_networks_wireless_alternate_management_interface = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id

          data = try(network.wireless_alternate_management_interface, null)
          access_points = [for ap in try(network.wireless_alternate_management_interface.access_points, []) : {
            alternate_management_ip = try(ap.alternate_management_ip, null)
            dns1                    = try(ap.dns1, null)
            dns2                    = try(ap.dns2, null)
            gateway                 = try(ap.gateway, null)
            serial                  = meraki_device.device["${organization.name}/${network.name}/devices/${ap.device}"].serial
            subnet_mask             = try(ap.subnet_mask, null)
          }]
        } if try(network.wireless_alternate_management_interface, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_wireless_alternate_management_interface" "wireless_alternate_management_interface" {
  for_each   = { for i, v in local.networks_networks_wireless_alternate_management_interface : i => v }
  network_id = each.value.network_id

  enabled       = try(each.value.data.enabled, local.defaults.meraki.networks.networks_wireless_alternate_management_interface.enabled, null)
  vlan_id       = try(each.value.data.vlan_id, local.defaults.meraki.networks.networks_wireless_alternate_management_interface.vlan_id, null)
  protocols     = try(each.value.data.protocols, local.defaults.meraki.networks.networks_wireless_alternate_management_interface.protocols, null)
  access_points = length(each.value.access_points) > 0 ? each.value.access_points : null
  depends_on = [
    meraki_wireless_ssid.net_wireless_ssids
  ]
}
locals {
  networks_networks_wireless_bluetooth_settings = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id

          data = try(network.wireless_bluetooth_settings, null)
        } if try(network.wireless_bluetooth_settings, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_wireless_network_bluetooth_settings" "wireless_bluetooth_settings" {
  for_each   = { for i, v in local.networks_networks_wireless_bluetooth_settings : i => v }
  network_id = each.value.network_id

  scanning_enabled            = try(each.value.data.scanning_enabled, local.defaults.meraki.networks.networks_wireless_bluetooth_settings.scanning_enabled, null)
  advertising_enabled         = try(each.value.data.advertising_enabled, local.defaults.meraki.networks.networks_wireless_bluetooth_settings.advertising_enabled, null)
  uuid                        = try(each.value.data.uuid, local.defaults.meraki.networks.networks_wireless_bluetooth_settings.uuid, null)
  major_minor_assignment_mode = try(each.value.data.major_minor_assignment_mode, local.defaults.meraki.networks.networks_wireless_bluetooth_settings.major_minor_assignment_mode, null)
  major                       = try(each.value.data.major, local.defaults.meraki.networks.networks_wireless_bluetooth_settings.major, null)
  minor                       = try(each.value.data.minor, local.defaults.meraki.networks.networks_wireless_bluetooth_settings.minor, null)
  depends_on = [
    meraki_wireless_ssid.net_wireless_ssids
  ]
}
