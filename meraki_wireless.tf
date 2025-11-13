locals {
  per_ssid_settings_list = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for wireless_rf_profile in try(network.wireless.rf_profiles, []) : [
            for settings in try(wireless_rf_profile.per_ssid_settings, []) : {
              key = format(
                "%s/%s/%s/%s/%s",
                domain.name,
                organization.name,
                network.name,
                wireless_rf_profile.name,
                meraki_wireless_ssid.networks_wireless_ssids[format("%s/%s/%s/%s", domain.name, organization.name, network.name, settings.ssid_name)].number,
              )
              min_bitrate           = try(settings.min_bitrate, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.per_ssid_settings.min_bitrate, null)
              band_operation_mode   = try(settings.band_operation_mode, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.per_ssid_settings.band_operation_mode, null)
              bands_enabled         = try(settings.bands, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.per_ssid_settings.bands, null)
              band_steering_enabled = try(settings.band_steering_enabled, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.per_ssid_settings.band_steering_enabled, null)
            }
          ]
        ]
      ]
    ]
  ])
  per_ssid_settings = { for s in local.per_ssid_settings_list : s.key => s }
  networks_wireless_rf_profiles = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for wireless_rf_profile in try(network.wireless.rf_profiles, []) : {
            key                                       = format("%s/%s/%s/%s", domain.name, organization.name, network.name, wireless_rf_profile.name)
            network_id                                = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
            per_ssid_settings                         = [for i in range(15) : try(local.per_ssid_settings[format("%s/%s/%s/%s/%s", domain.name, organization.name, network.name, wireless_rf_profile.name, i)], null)]
            name                                      = try(wireless_rf_profile.name, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.name, null)
            client_balancing_enabled                  = try(wireless_rf_profile.client_balancing, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.client_balancing, null)
            min_bitrate_type                          = try(wireless_rf_profile.min_bitrate_type, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.min_bitrate_type, null)
            band_selection_type                       = try(wireless_rf_profile.band_selection_type, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.band_selection_type, null)
            ap_band_settings_band_operation_mode      = try(wireless_rf_profile.ap_band_settings.band_operation_mode, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.ap_band_settings.band_operation_mode, null)
            ap_band_settings_bands_enabled            = try(wireless_rf_profile.ap_band_settings.bands, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.ap_band_settings.bands, null)
            ap_band_settings_band_steering_enabled    = try(wireless_rf_profile.ap_band_settings.band_steering_enabled, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.ap_band_settings.band_steering_enabled, null)
            two_four_ghz_settings_max_power           = try(wireless_rf_profile.two_four_ghz_settings.max_power, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.two_four_ghz_settings.max_power, null)
            two_four_ghz_settings_min_power           = try(wireless_rf_profile.two_four_ghz_settings.min_power, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.two_four_ghz_settings.min_power, null)
            two_four_ghz_settings_min_bitrate         = try(wireless_rf_profile.two_four_ghz_settings.min_bitrate, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.two_four_ghz_settings.min_bitrate, null)
            two_four_ghz_settings_valid_auto_channels = try(wireless_rf_profile.two_four_ghz_settings.valid_auto_channels, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.two_four_ghz_settings.valid_auto_channels, null)
            two_four_ghz_settings_ax_enabled          = try(wireless_rf_profile.two_four_ghz_settings.ax, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.two_four_ghz_settings.ax, null)
            two_four_ghz_settings_rxsop               = try(wireless_rf_profile.two_four_ghz_settings.rxsop, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.two_four_ghz_settings.rxsop, null)
            five_ghz_settings_max_power               = try(wireless_rf_profile.five_ghz_settings.max_power, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.five_ghz_settings.max_power, null)
            five_ghz_settings_min_power               = try(wireless_rf_profile.five_ghz_settings.min_power, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.five_ghz_settings.min_power, null)
            five_ghz_settings_min_bitrate             = try(wireless_rf_profile.five_ghz_settings.min_bitrate, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.five_ghz_settings.min_bitrate, null)
            five_ghz_settings_valid_auto_channels     = try(wireless_rf_profile.five_ghz_settings.valid_auto_channels, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.five_ghz_settings.valid_auto_channels, null)
            five_ghz_settings_channel_width           = try(wireless_rf_profile.five_ghz_settings.channel_width, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.five_ghz_settings.channel_width, null)
            five_ghz_settings_rxsop                   = try(wireless_rf_profile.five_ghz_settings.rxsop, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.five_ghz_settings.rxsop, null)
            six_ghz_settings_max_power                = try(wireless_rf_profile.six_ghz_settings.max_power, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.six_ghz_settings.max_power, null)
            six_ghz_settings_min_power                = try(wireless_rf_profile.six_ghz_settings.min_power, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.six_ghz_settings.min_power, null)
            six_ghz_settings_min_bitrate              = try(wireless_rf_profile.six_ghz_settings.min_bitrate, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.six_ghz_settings.min_bitrate, null)
            six_ghz_settings_valid_auto_channels      = try(wireless_rf_profile.six_ghz_settings.valid_auto_channels, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.six_ghz_settings.valid_auto_channels, null)
            six_ghz_settings_channel_width            = try(wireless_rf_profile.six_ghz_settings.channel_width, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.six_ghz_settings.channel_width, null)
            six_ghz_settings_rxsop                    = try(wireless_rf_profile.six_ghz_settings.rxsop, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.six_ghz_settings.rxsop, null)
            transmission_enabled                      = try(wireless_rf_profile.transmission, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.transmission, null)
            flex_radios_by_model = try(length(wireless_rf_profile.flex_radios) == 0, true) ? null : [
              for by_model in try(wireless_rf_profile.flex_radios, []) : {
                model = try(by_model.model, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.flex_radios.model, null)
                bands = try(by_model.bands, local.defaults.meraki.domains.organizations.networks.wireless.rf_profiles.flex_radios.bands, null)
              }
            ]
          }
        ]
      ]
    ]
  ])
}

resource "meraki_wireless_rf_profile" "networks_wireless_rf_profiles" {
  for_each                                   = { for v in local.networks_wireless_rf_profiles : v.key => v }
  network_id                                 = each.value.network_id
  name                                       = each.value.name
  client_balancing_enabled                   = each.value.client_balancing_enabled
  min_bitrate_type                           = each.value.min_bitrate_type
  band_selection_type                        = each.value.band_selection_type
  ap_band_settings_band_operation_mode       = each.value.ap_band_settings_band_operation_mode
  ap_band_settings_bands_enabled             = each.value.ap_band_settings_bands_enabled
  ap_band_settings_band_steering_enabled     = each.value.ap_band_settings_band_steering_enabled
  two_four_ghz_settings_max_power            = each.value.two_four_ghz_settings_max_power
  two_four_ghz_settings_min_power            = each.value.two_four_ghz_settings_min_power
  two_four_ghz_settings_min_bitrate          = each.value.two_four_ghz_settings_min_bitrate
  two_four_ghz_settings_valid_auto_channels  = each.value.two_four_ghz_settings_valid_auto_channels
  two_four_ghz_settings_ax_enabled           = each.value.two_four_ghz_settings_ax_enabled
  two_four_ghz_settings_rxsop                = each.value.two_four_ghz_settings_rxsop
  five_ghz_settings_max_power                = each.value.five_ghz_settings_max_power
  five_ghz_settings_min_power                = each.value.five_ghz_settings_min_power
  five_ghz_settings_min_bitrate              = each.value.five_ghz_settings_min_bitrate
  five_ghz_settings_valid_auto_channels      = each.value.five_ghz_settings_valid_auto_channels
  five_ghz_settings_channel_width            = each.value.five_ghz_settings_channel_width
  five_ghz_settings_rxsop                    = each.value.five_ghz_settings_rxsop
  six_ghz_settings_max_power                 = each.value.six_ghz_settings_max_power
  six_ghz_settings_min_power                 = each.value.six_ghz_settings_min_power
  six_ghz_settings_min_bitrate               = each.value.six_ghz_settings_min_bitrate
  six_ghz_settings_valid_auto_channels       = each.value.six_ghz_settings_valid_auto_channels
  six_ghz_settings_channel_width             = each.value.six_ghz_settings_channel_width
  six_ghz_settings_rxsop                     = each.value.six_ghz_settings_rxsop
  transmission_enabled                       = each.value.transmission_enabled
  per_ssid_settings_0_min_bitrate            = try(each.value.per_ssid_settings[0].min_bitrate, null)
  per_ssid_settings_0_band_operation_mode    = try(each.value.per_ssid_settings[0].band_operation_mode, null)
  per_ssid_settings_0_bands_enabled          = try(each.value.per_ssid_settings[0].bands, null)
  per_ssid_settings_0_band_steering_enabled  = try(each.value.per_ssid_settings[0].band_steering_enabled, null)
  per_ssid_settings_1_min_bitrate            = try(each.value.per_ssid_settings[1].min_bitrate, null)
  per_ssid_settings_1_band_operation_mode    = try(each.value.per_ssid_settings[1].band_operation_mode, null)
  per_ssid_settings_1_bands_enabled          = try(each.value.per_ssid_settings[1].bands, null)
  per_ssid_settings_1_band_steering_enabled  = try(each.value.per_ssid_settings[1].band_steering_enabled, null)
  per_ssid_settings_2_min_bitrate            = try(each.value.per_ssid_settings[2].min_bitrate, null)
  per_ssid_settings_2_band_operation_mode    = try(each.value.per_ssid_settings[2].band_operation_mode, null)
  per_ssid_settings_2_bands_enabled          = try(each.value.per_ssid_settings[2].bands, null)
  per_ssid_settings_2_band_steering_enabled  = try(each.value.per_ssid_settings[2].band_steering_enabled, null)
  per_ssid_settings_3_min_bitrate            = try(each.value.per_ssid_settings[3].min_bitrate, null)
  per_ssid_settings_3_band_operation_mode    = try(each.value.per_ssid_settings[3].band_operation_mode, null)
  per_ssid_settings_3_bands_enabled          = try(each.value.per_ssid_settings[3].bands, null)
  per_ssid_settings_3_band_steering_enabled  = try(each.value.per_ssid_settings[3].band_steering_enabled, null)
  per_ssid_settings_4_min_bitrate            = try(each.value.per_ssid_settings[4].min_bitrate, null)
  per_ssid_settings_4_band_operation_mode    = try(each.value.per_ssid_settings[4].band_operation_mode, null)
  per_ssid_settings_4_bands_enabled          = try(each.value.per_ssid_settings[4].bands, null)
  per_ssid_settings_4_band_steering_enabled  = try(each.value.per_ssid_settings[4].band_steering_enabled, null)
  per_ssid_settings_5_min_bitrate            = try(each.value.per_ssid_settings[5].min_bitrate, null)
  per_ssid_settings_5_band_operation_mode    = try(each.value.per_ssid_settings[5].band_operation_mode, null)
  per_ssid_settings_5_bands_enabled          = try(each.value.per_ssid_settings[5].bands, null)
  per_ssid_settings_5_band_steering_enabled  = try(each.value.per_ssid_settings[5].band_steering_enabled, null)
  per_ssid_settings_6_min_bitrate            = try(each.value.per_ssid_settings[6].min_bitrate, null)
  per_ssid_settings_6_band_operation_mode    = try(each.value.per_ssid_settings[6].band_operation_mode, null)
  per_ssid_settings_6_bands_enabled          = try(each.value.per_ssid_settings[6].bands, null)
  per_ssid_settings_6_band_steering_enabled  = try(each.value.per_ssid_settings[6].band_steering_enabled, null)
  per_ssid_settings_7_min_bitrate            = try(each.value.per_ssid_settings[7].min_bitrate, null)
  per_ssid_settings_7_band_operation_mode    = try(each.value.per_ssid_settings[7].band_operation_mode, null)
  per_ssid_settings_7_bands_enabled          = try(each.value.per_ssid_settings[7].bands, null)
  per_ssid_settings_7_band_steering_enabled  = try(each.value.per_ssid_settings[7].band_steering_enabled, null)
  per_ssid_settings_8_min_bitrate            = try(each.value.per_ssid_settings[8].min_bitrate, null)
  per_ssid_settings_8_band_operation_mode    = try(each.value.per_ssid_settings[8].band_operation_mode, null)
  per_ssid_settings_8_bands_enabled          = try(each.value.per_ssid_settings[8].bands, null)
  per_ssid_settings_8_band_steering_enabled  = try(each.value.per_ssid_settings[8].band_steering_enabled, null)
  per_ssid_settings_9_min_bitrate            = try(each.value.per_ssid_settings[9].min_bitrate, null)
  per_ssid_settings_9_band_operation_mode    = try(each.value.per_ssid_settings[9].band_operation_mode, null)
  per_ssid_settings_9_bands_enabled          = try(each.value.per_ssid_settings[9].bands, null)
  per_ssid_settings_9_band_steering_enabled  = try(each.value.per_ssid_settings[9].band_steering_enabled, null)
  per_ssid_settings_10_min_bitrate           = try(each.value.per_ssid_settings[10].min_bitrate, null)
  per_ssid_settings_10_band_operation_mode   = try(each.value.per_ssid_settings[10].band_operation_mode, null)
  per_ssid_settings_10_bands_enabled         = try(each.value.per_ssid_settings[10].bands, null)
  per_ssid_settings_10_band_steering_enabled = try(each.value.per_ssid_settings[10].band_steering_enabled, null)
  per_ssid_settings_11_min_bitrate           = try(each.value.per_ssid_settings[11].min_bitrate, null)
  per_ssid_settings_11_band_operation_mode   = try(each.value.per_ssid_settings[11].band_operation_mode, null)
  per_ssid_settings_11_bands_enabled         = try(each.value.per_ssid_settings[11].bands, null)
  per_ssid_settings_11_band_steering_enabled = try(each.value.per_ssid_settings[11].band_steering_enabled, null)
  per_ssid_settings_12_min_bitrate           = try(each.value.per_ssid_settings[12].min_bitrate, null)
  per_ssid_settings_12_band_operation_mode   = try(each.value.per_ssid_settings[12].band_operation_mode, null)
  per_ssid_settings_12_bands_enabled         = try(each.value.per_ssid_settings[12].bands, null)
  per_ssid_settings_12_band_steering_enabled = try(each.value.per_ssid_settings[12].band_steering_enabled, null)
  per_ssid_settings_13_min_bitrate           = try(each.value.per_ssid_settings[13].min_bitrate, null)
  per_ssid_settings_13_band_operation_mode   = try(each.value.per_ssid_settings[13].band_operation_mode, null)
  per_ssid_settings_13_bands_enabled         = try(each.value.per_ssid_settings[13].bands, null)
  per_ssid_settings_13_band_steering_enabled = try(each.value.per_ssid_settings[13].band_steering_enabled, null)
  per_ssid_settings_14_min_bitrate           = try(each.value.per_ssid_settings[14].min_bitrate, null)
  per_ssid_settings_14_band_operation_mode   = try(each.value.per_ssid_settings[14].band_operation_mode, null)
  per_ssid_settings_14_bands_enabled         = try(each.value.per_ssid_settings[14].bands, null)
  per_ssid_settings_14_band_steering_enabled = try(each.value.per_ssid_settings[14].band_steering_enabled, null)
  flex_radios_by_model                       = each.value.flex_radios_by_model
}

locals {
  networks_wireless_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                                       = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id                                = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          meshing_enabled                           = try(network.wireless.settings.meshing, local.defaults.meraki.domains.organizations.networks.wireless.settings.meshing, null)
          ipv6_bridge_enabled                       = try(network.wireless.settings.ipv6_bridge, local.defaults.meraki.domains.organizations.networks.wireless.settings.ipv6_bridge, null)
          location_analytics_enabled                = try(network.wireless.settings.location_analytics, local.defaults.meraki.domains.organizations.networks.wireless.settings.location_analytics, null)
          upgrade_strategy                          = try(network.wireless.settings.upgrade_strategy, local.defaults.meraki.domains.organizations.networks.wireless.settings.upgrade_strategy, null)
          led_lights_on                             = try(network.wireless.settings.led_lights_on, local.defaults.meraki.domains.organizations.networks.wireless.settings.led_lights_on, null)
          named_vlans_pool_dhcp_monitoring_enabled  = try(network.wireless.settings.named_vlans.pool_dhcp_monitoring.enabled, local.defaults.meraki.domains.organizations.networks.wireless.settings.named_vlans.pool_dhcp_monitoring.enabled, null)
          named_vlans_pool_dhcp_monitoring_duration = try(network.wireless.settings.named_vlans.pool_dhcp_monitoring.duration, local.defaults.meraki.domains.organizations.networks.wireless.settings.named_vlans.pool_dhcp_monitoring.duration, null)
        } if try(network.wireless.settings, null) != null
      ]
    ]
  ])
}

resource "meraki_wireless_settings" "networks_wireless_settings" {
  for_each                                  = { for v in local.networks_wireless_settings : v.key => v }
  network_id                                = each.value.network_id
  meshing_enabled                           = each.value.meshing_enabled
  ipv6_bridge_enabled                       = each.value.ipv6_bridge_enabled
  location_analytics_enabled                = each.value.location_analytics_enabled
  upgrade_strategy                          = each.value.upgrade_strategy
  led_lights_on                             = each.value.led_lights_on
  named_vlans_pool_dhcp_monitoring_enabled  = each.value.named_vlans_pool_dhcp_monitoring_enabled
  named_vlans_pool_dhcp_monitoring_duration = each.value.named_vlans_pool_dhcp_monitoring_duration
}

locals {
  networks_wireless_ssids = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for wireless_ssid in try(network.wireless.ssids, []) : {
            key                                                                         = format("%s/%s/%s/%s", domain.name, organization.name, network.name, try(wireless_ssid.name, "unknown")) # Use "unknown" if name is missing
            network_id                                                                  = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
            number                                                                      = wireless_ssid.ssid_number
            name                                                                        = try(wireless_ssid.name, local.defaults.meraki.domains.organizations.networks.wireless.ssids.name, null)
            enabled                                                                     = try(wireless_ssid.enabled, local.defaults.meraki.domains.organizations.networks.wireless.ssids.enabled, null)
            auth_mode                                                                   = try(wireless_ssid.auth_mode, local.defaults.meraki.domains.organizations.networks.wireless.ssids.auth_mode, null)
            enterprise_admin_access                                                     = try(wireless_ssid.enterprise_admin_access, local.defaults.meraki.domains.organizations.networks.wireless.ssids.enterprise_admin_access, null)
            encryption_mode                                                             = try(wireless_ssid.encryption_mode, local.defaults.meraki.domains.organizations.networks.wireless.ssids.encryption_mode, null)
            psk                                                                         = try(wireless_ssid.psk, local.defaults.meraki.domains.organizations.networks.wireless.ssids.psk, null)
            wpa_encryption_mode                                                         = try(wireless_ssid.wpa_encryption_mode, local.defaults.meraki.domains.organizations.networks.wireless.ssids.wpa_encryption_mode, null)
            dot11w_enabled                                                              = try(wireless_ssid.dot11w.enabled, local.defaults.meraki.domains.organizations.networks.wireless.ssids.dot11w.enabled, null)
            dot11w_required                                                             = try(wireless_ssid.dot11w.required, local.defaults.meraki.domains.organizations.networks.wireless.ssids.dot11w.required, null)
            dot11r_enabled                                                              = try(wireless_ssid.dot11r.enabled, local.defaults.meraki.domains.organizations.networks.wireless.ssids.dot11r.enabled, null)
            dot11r_adaptive                                                             = try(wireless_ssid.dot11r.adaptive, local.defaults.meraki.domains.organizations.networks.wireless.ssids.dot11r.adaptive, null)
            splash_page                                                                 = try(wireless_ssid.splash_page, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_page, null)
            splash_guest_sponsor_domains                                                = try(wireless_ssid.splash_guest_sponsor_domains, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_guest_sponsor_domains, null)
            oauth_allowed_domains                                                       = try(wireless_ssid.oauth_allowed_domains, local.defaults.meraki.domains.organizations.networks.wireless.ssids.oauth_allowed_domains, null)
            local_radius_cache_timeout                                                  = try(wireless_ssid.radius.local_radius.cache_timeout, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.local_radius.cache_timeout, null)
            local_radius_password_authentication_enabled                                = try(wireless_ssid.radius.local_radius.password_authentication, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.local_radius.password_authentication, null)
            local_radius_certificate_authentication_enabled                             = try(wireless_ssid.radius.local_radius.certificate_authentication.enabled, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.local_radius.certificate_authentication.enabled, null)
            local_radius_certificate_authentication_use_ldap                            = try(wireless_ssid.radius.local_radius.certificate_authentication.use_ldap, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.local_radius.certificate_authentication.use_ldap, null)
            local_radius_certificate_authentication_use_ocsp                            = try(wireless_ssid.radius.local_radius.certificate_authentication.use_ocsp, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.local_radius.certificate_authentication.use_ocsp, null)
            local_radius_certificate_authentication_ocsp_responder_url                  = try(wireless_ssid.radius.local_radius.certificate_authentication.ocsp_responder_url, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.local_radius.certificate_authentication.ocsp_responder_url, null)
            local_radius_certificate_authentication_client_root_ca_certificate_contents = try(wireless_ssid.radius.local_radius.certificate_authentication.client_root_ca_certificate, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.local_radius.certificate_authentication.client_root_ca_certificate, null)
            ldap_servers = try(length(wireless_ssid.ldap.servers) == 0, true) ? null : [
              for server in try(wireless_ssid.ldap.servers, []) : {
                host = try(server.host, local.defaults.meraki.domains.organizations.networks.wireless.ssids.ldap.servers.host, null)
                port = try(server.port, local.defaults.meraki.domains.organizations.networks.wireless.ssids.ldap.servers.port, null)
              }
            ]
            ldap_credentials_distinguished_name = try(wireless_ssid.ldap.credentials.distinguished_name, local.defaults.meraki.domains.organizations.networks.wireless.ssids.ldap.credentials.distinguished_name, null)
            ldap_credentials_password           = try(wireless_ssid.ldap.credentials.password, local.defaults.meraki.domains.organizations.networks.wireless.ssids.ldap.credentials.password, null)
            ldap_base_distinguished_name        = try(wireless_ssid.ldap.base_distinguished_name, local.defaults.meraki.domains.organizations.networks.wireless.ssids.ldap.base_distinguished_name, null)
            ldap_server_ca_certificate_contents = try(wireless_ssid.ldap.server_ca_certificate, local.defaults.meraki.domains.organizations.networks.wireless.ssids.ldap.server_ca_certificate, null)
            active_directory_servers = try(length(wireless_ssid.active_directory.servers) == 0, true) ? null : [
              for server in try(wireless_ssid.active_directory.servers, []) : {
                host = try(server.host, local.defaults.meraki.domains.organizations.networks.wireless.ssids.active_directory.servers.host, null)
                port = try(server.port, local.defaults.meraki.domains.organizations.networks.wireless.ssids.active_directory.servers.port, null)
              }
            ]
            active_directory_credentials_logon_name = try(wireless_ssid.active_directory.credentials.logon_name, local.defaults.meraki.domains.organizations.networks.wireless.ssids.active_directory.credentials.logon_name, null)
            active_directory_credentials_password   = try(wireless_ssid.active_directory.credentials.password, local.defaults.meraki.domains.organizations.networks.wireless.ssids.active_directory.credentials.password, null)
            radius_servers = try(length(wireless_ssid.radius.servers) == 0, true) ? null : [
              for radius_server in try(wireless_ssid.radius.servers, []) : {
                host                        = try(radius_server.host, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.servers.host, null)
                port                        = try(radius_server.port, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.servers.port, null)
                secret                      = try(radius_server.secret, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.servers.secret, null)
                radsec_enabled              = try(radius_server.radsec, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.servers.radsec, null)
                open_roaming_certificate_id = try(radius_server.open_roaming_certificate_id, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.servers.open_roaming_certificate_id, null)
                ca_certificate              = try(radius_server.ca_certificate, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.servers.ca_certificate, null)
              }
            ]
            radius_proxy_enabled             = try(wireless_ssid.radius.proxy, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.proxy, null)
            radius_testing_enabled           = try(wireless_ssid.radius.testing, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.testing, null)
            radius_called_station_id         = try(wireless_ssid.radius.called_station_id, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.called_station_id, null)
            radius_authentication_nas_id     = try(wireless_ssid.radius.authentication_nas_id, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.authentication_nas_id, null)
            radius_server_timeout            = try(wireless_ssid.radius.server_timeout, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.server_timeout, null)
            radius_server_attempts_limit     = try(wireless_ssid.radius.server_attempts_limit, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.server_attempts_limit, null)
            radius_fallback_enabled          = try(wireless_ssid.radius.fallback, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.fallback, null)
            radius_radsec_tls_tunnel_timeout = try(wireless_ssid.radius.radsec_tls_tunnel_timeout, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.radsec_tls_tunnel_timeout, null)
            radius_coa_enabled               = try(wireless_ssid.radius.coa, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.coa, null)
            radius_failover_policy           = try(wireless_ssid.radius.failover_policy, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.failover_policy, null)
            radius_load_balancing_policy     = try(wireless_ssid.radius.load_balancing_policy, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.load_balancing_policy, null)
            radius_accounting_enabled        = try(wireless_ssid.radius.accounting, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.accounting, null)
            radius_accounting_servers = try(length(wireless_ssid.radius.accounting_servers) == 0, true) ? null : [
              for radius_accounting_server in try(wireless_ssid.radius.accounting_servers, []) : {
                host           = try(radius_accounting_server.host, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.accounting_servers.host, null)
                port           = try(radius_accounting_server.port, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.accounting_servers.port, null)
                secret         = try(radius_accounting_server.secret, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.accounting_servers.secret, null)
                radsec_enabled = try(radius_accounting_server.radsec, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.accounting_servers.radsec, null)
                ca_certificate = try(radius_accounting_server.ca_certificate, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.accounting_servers.ca_certificate, null)
              }
            ]
            radius_accounting_interim_interval  = try(wireless_ssid.radius.accounting_interim_interval, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.accounting_interim_interval, null)
            radius_attribute_for_group_policies = try(wireless_ssid.radius.attribute_for_group_policies, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.attribute_for_group_policies, null)
            ip_assignment_mode                  = try(wireless_ssid.ip_assignment_mode, local.defaults.meraki.domains.organizations.networks.wireless.ssids.ip_assignment_mode, null)
            use_vlan_tagging                    = try(wireless_ssid.use_vlan_tagging, local.defaults.meraki.domains.organizations.networks.wireless.ssids.use_vlan_tagging, null)
            # TODO Map from concentrator_network_name
            concentrator_network_id = try(wireless_ssid.concentrator_network_id, local.defaults.meraki.domains.organizations.networks.wireless.ssids.concentrator_network_id, null)
            # TODO Map from secondary_concentrator_network_name
            secondary_concentrator_network_id    = try(wireless_ssid.secondary_concentrator_network_id, local.defaults.meraki.domains.organizations.networks.wireless.ssids.secondary_concentrator_network_id, null)
            disassociate_clients_on_vpn_failover = try(wireless_ssid.disassociate_clients_on_vpn_failover, local.defaults.meraki.domains.organizations.networks.wireless.ssids.disassociate_clients_on_vpn_failover, null)
            vlan_id                              = try(wireless_ssid.vlan_id, local.defaults.meraki.domains.organizations.networks.wireless.ssids.vlan_id, null)
            default_vlan_id                      = try(wireless_ssid.default_vlan_id, local.defaults.meraki.domains.organizations.networks.wireless.ssids.default_vlan_id, null)
            ap_tags_and_vlan_ids = try(length(wireless_ssid.ap_tags_and_vlan_ids) == 0, true) ? null : [
              for ap_tags_and_vlan_id in try(wireless_ssid.ap_tags_and_vlan_ids, []) : {
                tags    = try(ap_tags_and_vlan_id.tags, local.defaults.meraki.domains.organizations.networks.wireless.ssids.ap_tags_and_vlan_ids.tags, null)
                vlan_id = try(ap_tags_and_vlan_id.vlan_id, local.defaults.meraki.domains.organizations.networks.wireless.ssids.ap_tags_and_vlan_ids.vlan_id, null)
              }
            ]
            walled_garden_enabled                 = try(wireless_ssid.walled_garden, local.defaults.meraki.domains.organizations.networks.wireless.ssids.walled_garden, null)
            walled_garden_ranges                  = try(wireless_ssid.walled_garden_ranges, local.defaults.meraki.domains.organizations.networks.wireless.ssids.walled_garden_ranges, null)
            gre_concentrator_host                 = try(wireless_ssid.gre.concentrator, local.defaults.meraki.domains.organizations.networks.wireless.ssids.gre.concentrator, null)
            gre_key                               = try(wireless_ssid.gre.key, local.defaults.meraki.domains.organizations.networks.wireless.ssids.gre.key, null)
            radius_override                       = try(wireless_ssid.radius.override, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.override, null)
            radius_guest_vlan_enabled             = try(wireless_ssid.radius.guest_vlan, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.guest_vlan, null)
            radius_guest_vlan_id                  = try(wireless_ssid.radius.guest_vlan_id, local.defaults.meraki.domains.organizations.networks.wireless.ssids.radius.guest_vlan_id, null)
            min_bitrate                           = try(wireless_ssid.min_bitrate, local.defaults.meraki.domains.organizations.networks.wireless.ssids.min_bitrate, null)
            band_selection                        = try(wireless_ssid.band_selection, local.defaults.meraki.domains.organizations.networks.wireless.ssids.band_selection, null)
            per_client_bandwidth_limit_up         = try(wireless_ssid.per_client_bandwidth_limit_up, local.defaults.meraki.domains.organizations.networks.wireless.ssids.per_client_bandwidth_limit_up, null)
            per_client_bandwidth_limit_down       = try(wireless_ssid.per_client_bandwidth_limit_down, local.defaults.meraki.domains.organizations.networks.wireless.ssids.per_client_bandwidth_limit_down, null)
            per_ssid_bandwidth_limit_up           = try(wireless_ssid.per_ssid_bandwidth_limit_up, local.defaults.meraki.domains.organizations.networks.wireless.ssids.per_ssid_bandwidth_limit_up, null)
            per_ssid_bandwidth_limit_down         = try(wireless_ssid.per_ssid_bandwidth_limit_down, local.defaults.meraki.domains.organizations.networks.wireless.ssids.per_ssid_bandwidth_limit_down, null)
            lan_isolation_enabled                 = try(wireless_ssid.lan_isolation, local.defaults.meraki.domains.organizations.networks.wireless.ssids.lan_isolation, null)
            visible                               = try(wireless_ssid.visible, local.defaults.meraki.domains.organizations.networks.wireless.ssids.visible, null)
            available_on_all_aps                  = try(wireless_ssid.available_on_all_aps, local.defaults.meraki.domains.organizations.networks.wireless.ssids.available_on_all_aps, null)
            availability_tags                     = try(wireless_ssid.availability_tags, local.defaults.meraki.domains.organizations.networks.wireless.ssids.availability_tags, null)
            mandatory_dhcp_enabled                = try(wireless_ssid.mandatory_dhcp, local.defaults.meraki.domains.organizations.networks.wireless.ssids.mandatory_dhcp, null)
            adult_content_filtering_enabled       = try(wireless_ssid.adult_content_filtering, local.defaults.meraki.domains.organizations.networks.wireless.ssids.adult_content_filtering, null)
            dns_rewrite_enabled                   = try(wireless_ssid.dns_rewrite.enabled, local.defaults.meraki.domains.organizations.networks.wireless.ssids.dns_rewrite.enabled, null)
            dns_rewrite_dns_custom_nameservers    = try(wireless_ssid.dns_rewrite.dns_custom_nameservers, local.defaults.meraki.domains.organizations.networks.wireless.ssids.dns_rewrite.dns_custom_nameservers, null)
            speed_burst_enabled                   = try(wireless_ssid.speed_burst, local.defaults.meraki.domains.organizations.networks.wireless.ssids.speed_burst, null)
            named_vlans_tagging_enabled           = try(wireless_ssid.named_vlans.tagging.enabled, local.defaults.meraki.domains.organizations.networks.wireless.ssids.named_vlans.tagging.enabled, null)
            named_vlans_tagging_default_vlan_name = try(wireless_ssid.named_vlans.tagging.default_vlan_name, local.defaults.meraki.domains.organizations.networks.wireless.ssids.named_vlans.tagging.default_vlan_name, null)
            named_vlans_tagging_by_ap_tags = try(length(wireless_ssid.named_vlans.tagging.by_ap_tags) == 0, true) ? null : [
              for by_ap_tag in try(wireless_ssid.named_vlans.tagging.by_ap_tags, []) : {
                tags      = try(by_ap_tag.tags, local.defaults.meraki.domains.organizations.networks.wireless.ssids.named_vlans.tagging.by_ap_tags.tags, null)
                vlan_name = try(by_ap_tag.vlan_name, local.defaults.meraki.domains.organizations.networks.wireless.ssids.named_vlans.tagging.by_ap_tags.vlan_name, null)
              }
            ]
            named_vlans_radius_guest_vlan_enabled = try(wireless_ssid.named_vlans.radius_guest_vlan.enabled, local.defaults.meraki.domains.organizations.networks.wireless.ssids.named_vlans.radius_guest_vlan.enabled, null)
            named_vlans_radius_guest_vlan_name    = try(wireless_ssid.named_vlans.radius_guest_vlan.name, local.defaults.meraki.domains.organizations.networks.wireless.ssids.named_vlans.radius_guest_vlan.name, null)
          }
        ]
      ]
    ]
  ])
}

resource "meraki_wireless_ssid" "networks_wireless_ssids" {
  for_each                                                                    = { for v in local.networks_wireless_ssids : v.key => v }
  network_id                                                                  = each.value.network_id
  number                                                                      = each.value.number
  name                                                                        = each.value.name
  enabled                                                                     = each.value.enabled
  auth_mode                                                                   = each.value.auth_mode
  enterprise_admin_access                                                     = each.value.enterprise_admin_access
  encryption_mode                                                             = each.value.encryption_mode
  psk                                                                         = each.value.psk
  wpa_encryption_mode                                                         = each.value.wpa_encryption_mode
  dot11w_enabled                                                              = each.value.dot11w_enabled
  dot11w_required                                                             = each.value.dot11w_required
  dot11r_enabled                                                              = each.value.dot11r_enabled
  dot11r_adaptive                                                             = each.value.dot11r_adaptive
  splash_page                                                                 = each.value.splash_page
  splash_guest_sponsor_domains                                                = each.value.splash_guest_sponsor_domains
  oauth_allowed_domains                                                       = each.value.oauth_allowed_domains
  local_radius_cache_timeout                                                  = each.value.local_radius_cache_timeout
  local_radius_password_authentication_enabled                                = each.value.local_radius_password_authentication_enabled
  local_radius_certificate_authentication_enabled                             = each.value.local_radius_certificate_authentication_enabled
  local_radius_certificate_authentication_use_ldap                            = each.value.local_radius_certificate_authentication_use_ldap
  local_radius_certificate_authentication_use_ocsp                            = each.value.local_radius_certificate_authentication_use_ocsp
  local_radius_certificate_authentication_ocsp_responder_url                  = each.value.local_radius_certificate_authentication_ocsp_responder_url
  local_radius_certificate_authentication_client_root_ca_certificate_contents = each.value.local_radius_certificate_authentication_client_root_ca_certificate_contents
  ldap_servers                                                                = each.value.ldap_servers
  ldap_credentials_distinguished_name                                         = each.value.ldap_credentials_distinguished_name
  ldap_credentials_password                                                   = each.value.ldap_credentials_password
  ldap_base_distinguished_name                                                = each.value.ldap_base_distinguished_name
  ldap_server_ca_certificate_contents                                         = each.value.ldap_server_ca_certificate_contents
  active_directory_servers                                                    = each.value.active_directory_servers
  active_directory_credentials_logon_name                                     = each.value.active_directory_credentials_logon_name
  active_directory_credentials_password                                       = each.value.active_directory_credentials_password
  radius_servers                                                              = each.value.radius_servers
  radius_proxy_enabled                                                        = each.value.radius_proxy_enabled
  radius_testing_enabled                                                      = each.value.radius_testing_enabled
  radius_called_station_id                                                    = each.value.radius_called_station_id
  radius_authentication_nas_id                                                = each.value.radius_authentication_nas_id
  radius_server_timeout                                                       = each.value.radius_server_timeout
  radius_server_attempts_limit                                                = each.value.radius_server_attempts_limit
  radius_fallback_enabled                                                     = each.value.radius_fallback_enabled
  radius_radsec_tls_tunnel_timeout                                            = each.value.radius_radsec_tls_tunnel_timeout
  radius_coa_enabled                                                          = each.value.radius_coa_enabled
  radius_failover_policy                                                      = each.value.radius_failover_policy
  radius_load_balancing_policy                                                = each.value.radius_load_balancing_policy
  radius_accounting_enabled                                                   = each.value.radius_accounting_enabled
  radius_accounting_servers                                                   = each.value.radius_accounting_servers
  radius_accounting_interim_interval                                          = each.value.radius_accounting_interim_interval
  radius_attribute_for_group_policies                                         = each.value.radius_attribute_for_group_policies
  ip_assignment_mode                                                          = each.value.ip_assignment_mode
  use_vlan_tagging                                                            = each.value.use_vlan_tagging
  concentrator_network_id                                                     = each.value.concentrator_network_id
  secondary_concentrator_network_id                                           = each.value.secondary_concentrator_network_id
  disassociate_clients_on_vpn_failover                                        = each.value.disassociate_clients_on_vpn_failover
  vlan_id                                                                     = each.value.vlan_id
  default_vlan_id                                                             = each.value.default_vlan_id
  ap_tags_and_vlan_ids                                                        = each.value.ap_tags_and_vlan_ids
  walled_garden_enabled                                                       = each.value.walled_garden_enabled
  walled_garden_ranges                                                        = each.value.walled_garden_ranges
  gre_concentrator_host                                                       = each.value.gre_concentrator_host
  gre_key                                                                     = each.value.gre_key
  radius_override                                                             = each.value.radius_override
  radius_guest_vlan_enabled                                                   = each.value.radius_guest_vlan_enabled
  radius_guest_vlan_id                                                        = each.value.radius_guest_vlan_id
  min_bitrate                                                                 = each.value.min_bitrate
  band_selection                                                              = each.value.band_selection
  per_client_bandwidth_limit_up                                               = each.value.per_client_bandwidth_limit_up
  per_client_bandwidth_limit_down                                             = each.value.per_client_bandwidth_limit_down
  per_ssid_bandwidth_limit_up                                                 = each.value.per_ssid_bandwidth_limit_up
  per_ssid_bandwidth_limit_down                                               = each.value.per_ssid_bandwidth_limit_down
  lan_isolation_enabled                                                       = each.value.lan_isolation_enabled
  visible                                                                     = each.value.visible
  available_on_all_aps                                                        = each.value.available_on_all_aps
  availability_tags                                                           = each.value.availability_tags
  mandatory_dhcp_enabled                                                      = each.value.mandatory_dhcp_enabled
  adult_content_filtering_enabled                                             = each.value.adult_content_filtering_enabled
  dns_rewrite_enabled                                                         = each.value.dns_rewrite_enabled
  dns_rewrite_dns_custom_nameservers                                          = each.value.dns_rewrite_dns_custom_nameservers
  speed_burst_enabled                                                         = each.value.speed_burst_enabled
  named_vlans_tagging_enabled                                                 = each.value.named_vlans_tagging_enabled
  named_vlans_tagging_default_vlan_name                                       = each.value.named_vlans_tagging_default_vlan_name
  named_vlans_tagging_by_ap_tags                                              = each.value.named_vlans_tagging_by_ap_tags
  named_vlans_radius_guest_vlan_enabled                                       = each.value.named_vlans_radius_guest_vlan_enabled
  named_vlans_radius_guest_vlan_name                                          = each.value.named_vlans_radius_guest_vlan_name
}

locals {
  networks_wireless_ssids_eap_override = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for wireless_ssid in try(network.wireless.ssids, []) : {
            key                     = format("%s/%s/%s/%s", domain.name, organization.name, network.name, wireless_ssid.name)
            network_id              = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
            number                  = meraki_wireless_ssid.networks_wireless_ssids[format("%s/%s/%s/%s", domain.name, organization.name, network.name, wireless_ssid.name)].number
            timeout                 = try(wireless_ssid.eap_override.timeout, local.defaults.meraki.domains.organizations.networks.wireless.ssids.eap_override.timeout, null)
            identity_retries        = try(wireless_ssid.eap_override.identity.retries, local.defaults.meraki.domains.organizations.networks.wireless.ssids.eap_override.identity.retries, null)
            identity_timeout        = try(wireless_ssid.eap_override.identity.timeout, local.defaults.meraki.domains.organizations.networks.wireless.ssids.eap_override.identity.timeout, null)
            max_retries             = try(wireless_ssid.eap_override.max_retries, local.defaults.meraki.domains.organizations.networks.wireless.ssids.eap_override.max_retries, null)
            eapol_key_retries       = try(wireless_ssid.eap_override.eapol_key.retries, local.defaults.meraki.domains.organizations.networks.wireless.ssids.eap_override.eapol_key.retries, null)
            eapol_key_timeout_in_ms = try(wireless_ssid.eap_override.eapol_key.timeout_in_ms, local.defaults.meraki.domains.organizations.networks.wireless.ssids.eap_override.eapol_key.timeout_in_ms, null)
          } if try(wireless_ssid.eap_override, null) != null
        ]
      ]
    ]
  ])
}

resource "meraki_wireless_ssid_eap_override" "networks_wireless_ssids_eap_override" {
  for_each                = { for v in local.networks_wireless_ssids_eap_override : v.key => v }
  network_id              = each.value.network_id
  number                  = each.value.number
  timeout                 = each.value.timeout
  identity_retries        = each.value.identity_retries
  identity_timeout        = each.value.identity_timeout
  max_retries             = each.value.max_retries
  eapol_key_retries       = each.value.eapol_key_retries
  eapol_key_timeout_in_ms = each.value.eapol_key_timeout_in_ms
}

locals {
  networks_wireless_ssids_device_type_group_policies = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for wireless_ssid in try(network.wireless.ssids, []) : {
            key        = format("%s/%s/%s/%s", domain.name, organization.name, network.name, wireless_ssid.name)
            network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
            number     = meraki_wireless_ssid.networks_wireless_ssids[format("%s/%s/%s/%s", domain.name, organization.name, network.name, wireless_ssid.name)].number
            enabled    = try(wireless_ssid.device_type_group_policies.enabled, local.defaults.meraki.domains.organizations.networks.wireless.ssids.device_type_group_policies.enabled, null)
            device_type_policies = try(length(wireless_ssid.device_type_group_policies.device_type_policies) == 0, true) ? null : [
              for device_type_policy in try(wireless_ssid.device_type_group_policies.device_type_policies, []) : {
                device_type     = try(device_type_policy.device_type, local.defaults.meraki.domains.organizations.networks.wireless.ssids.device_type_group_policies.device_type_policies.device_type, null)
                device_policy   = try(device_type_policy.device_policy, local.defaults.meraki.domains.organizations.networks.wireless.ssids.device_type_group_policies.device_type_policies.device_policy, null)
                group_policy_id = try(meraki_network_group_policy.networks_group_policies[format("%s/%s/%s/%s", domain.name, organization.name, network.name, device_type_policy.group_policy_name)].id, null)
              }
            ]
          } if try(wireless_ssid.device_type_group_policies, null) != null
        ]
      ]
    ]
  ])
}

resource "meraki_wireless_ssid_device_type_group_policies" "networks_wireless_ssids_device_type_group_policies" {
  for_each             = { for v in local.networks_wireless_ssids_device_type_group_policies : v.key => v }
  network_id           = each.value.network_id
  number               = each.value.number
  enabled              = each.value.enabled
  device_type_policies = each.value.device_type_policies
}

locals {
  networks_wireless_ssids_firewall_l3_firewall_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for wireless_ssid in try(network.wireless.ssids, []) : {
            key        = format("%s/%s/%s/%s", domain.name, organization.name, network.name, wireless_ssid.name)
            network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
            number     = meraki_wireless_ssid.networks_wireless_ssids[format("%s/%s/%s/%s", domain.name, organization.name, network.name, wireless_ssid.name)].number
            rules = try(length(wireless_ssid.firewall_l3_firewall_rules.rules) == 0, true) ? null : [
              for rule in try(wireless_ssid.firewall_l3_firewall_rules.rules, []) : {
                comment    = try(rule.comment, local.defaults.meraki.domains.organizations.networks.wireless.ssids.firewall_l3_firewall_rules.rules.comment, null)
                policy     = try(rule.policy, local.defaults.meraki.domains.organizations.networks.wireless.ssids.firewall_l3_firewall_rules.rules.policy, null)
                protocol   = try(rule.protocol, local.defaults.meraki.domains.organizations.networks.wireless.ssids.firewall_l3_firewall_rules.rules.protocol, null)
                dest_port  = try(rule.destination_port, local.defaults.meraki.domains.organizations.networks.wireless.ssids.firewall_l3_firewall_rules.rules.destination_port, null)
                dest_cidr  = try(rule.destination_cidr, local.defaults.meraki.domains.organizations.networks.wireless.ssids.firewall_l3_firewall_rules.rules.destination_cidr, null)
                ip_version = try(rule.ip_version, local.defaults.meraki.domains.organizations.networks.wireless.ssids.firewall_l3_firewall_rules.rules.ip_version, null)
              }
            ]
            allow_lan_access = try(wireless_ssid.firewall_l3_firewall_rules.allow_lan_access, local.defaults.meraki.domains.organizations.networks.wireless.ssids.firewall_l3_firewall_rules.allow_lan_access, null)
          } if try(wireless_ssid.firewall_l3_firewall_rules, null) != null
        ]
      ]
    ]
  ])
}

resource "meraki_wireless_ssid_l3_firewall_rules" "networks_wireless_ssids_firewall_l3_firewall_rules" {
  for_each         = { for v in local.networks_wireless_ssids_firewall_l3_firewall_rules : v.key => v }
  network_id       = each.value.network_id
  number           = each.value.number
  rules            = each.value.rules
  allow_lan_access = each.value.allow_lan_access
}


locals {
  networks_wireless_ssids_hotspot20 = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for wireless_ssid in try(network.wireless.ssids, []) : {
            key                 = format("%s/%s/%s/%s", domain.name, organization.name, network.name, wireless_ssid.name)
            network_id          = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
            number              = meraki_wireless_ssid.networks_wireless_ssids[format("%s/%s/%s/%s", domain.name, organization.name, network.name, wireless_ssid.name)].number
            enabled             = try(wireless_ssid.hotspot20.enabled, local.defaults.meraki.domains.organizations.networks.wireless.ssids.hotspot20.enabled, null)
            operator_name       = try(wireless_ssid.hotspot20.operator, local.defaults.meraki.domains.organizations.networks.wireless.ssids.hotspot20.operator, null)
            venue_name          = try(wireless_ssid.hotspot20.venue.name, local.defaults.meraki.domains.organizations.networks.wireless.ssids.hotspot20.venue.name, null)
            venue_type          = try(wireless_ssid.hotspot20.venue.type, local.defaults.meraki.domains.organizations.networks.wireless.ssids.hotspot20.venue.type, null)
            network_access_type = try(wireless_ssid.hotspot20.network_access_type, local.defaults.meraki.domains.organizations.networks.wireless.ssids.hotspot20.network_access_type, null)
            domains             = try(wireless_ssid.hotspot20.domains, local.defaults.meraki.domains.organizations.networks.wireless.ssids.hotspot20.domains, null)
            roam_consort_ois    = try(wireless_ssid.hotspot20.roam_consort_ois, local.defaults.meraki.domains.organizations.networks.wireless.ssids.hotspot20.roam_consort_ois, null)
            mcc_mncs = try(length(wireless_ssid.hotspot20.mcc_mncs) == 0, true) ? null : [
              for mcc_mnc in try(wireless_ssid.hotspot20.mcc_mncs, []) : {
                mcc = try(mcc_mnc.mcc, local.defaults.meraki.domains.organizations.networks.wireless.ssids.hotspot20.mcc_mncs.mcc, null)
                mnc = try(mcc_mnc.mnc, local.defaults.meraki.domains.organizations.networks.wireless.ssids.hotspot20.mcc_mncs.mnc, null)
              }
            ]
            nai_realms = try(length(wireless_ssid.hotspot20.nai_realms) == 0, true) ? null : [
              for nai_realm in try(wireless_ssid.hotspot20.nai_realms, []) : {
                format = try(nai_realm.format, local.defaults.meraki.domains.organizations.networks.wireless.ssids.hotspot20.nai_realms.format, null)
                realm  = try(nai_realm.realm, local.defaults.meraki.domains.organizations.networks.wireless.ssids.hotspot20.nai_realms.realm, null)
                methods = try(length(nai_realm.methods) == 0, true) ? null : [
                  for method in try(nai_realm.methods, []) : {
                    id                                                   = try(method.id, local.defaults.meraki.domains.organizations.networks.wireless.ssids.hotspot20.nai_realms.methods.id, null)
                    authentication_types_non_eap_inner_authentication    = try(method.authentication_types.non_eap_inner_authentication, local.defaults.meraki.domains.organizations.networks.wireless.ssids.hotspot20.nai_realms.methods.authentication_types.non_eap_inner_authentication, null)
                    authentication_types_eap_inner_authentication        = try(method.authentication_types.eap_inner_authentication, local.defaults.meraki.domains.organizations.networks.wireless.ssids.hotspot20.nai_realms.methods.authentication_types.eap_inner_authentication, null)
                    authentication_types_credentials                     = try(method.authentication_types.credentials, local.defaults.meraki.domains.organizations.networks.wireless.ssids.hotspot20.nai_realms.methods.authentication_types.credentials, null)
                    authentication_types_tunneled_eap_method_credentials = try(method.authentication_types.tunneled_eap_method_credentials, local.defaults.meraki.domains.organizations.networks.wireless.ssids.hotspot20.nai_realms.methods.authentication_types.tunneled_eap_method_credentials, null)
                  }
                ]
              }
            ]
          } if try(wireless_ssid.hotspot20, null) != null
        ]
      ]
    ]
  ])
}

resource "meraki_wireless_ssid_hotspot_20" "networks_wireless_ssids_hotspot20" {
  for_each            = { for v in local.networks_wireless_ssids_hotspot20 : v.key => v }
  network_id          = each.value.network_id
  number              = each.value.number
  enabled             = each.value.enabled
  operator_name       = each.value.operator_name
  venue_name          = each.value.venue_name
  venue_type          = each.value.venue_type
  network_access_type = each.value.network_access_type
  domains             = each.value.domains
  roam_consort_ois    = each.value.roam_consort_ois
  mcc_mncs            = each.value.mcc_mncs
  nai_realms          = each.value.nai_realms
}

locals {
  networks_wireless_ssids_identity_psks = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for wireless_ssid in try(network.wireless.ssids, []) : [
            for identity_psk in try(wireless_ssid.identity_psks, []) : {
              key             = format("%s/%s/%s/%s/%s", domain.name, organization.name, network.name, wireless_ssid.name, identity_psk.name)
              network_id      = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
              number          = meraki_wireless_ssid.networks_wireless_ssids[format("%s/%s/%s/%s", domain.name, organization.name, network.name, wireless_ssid.name)].number
              name            = try(identity_psk.name, local.defaults.meraki.domains.organizations.networks.wireless.ssids.identity_psks.name, null)
              passphrase      = try(identity_psk.passphrase, local.defaults.meraki.domains.organizations.networks.wireless.ssids.identity_psks.passphrase, null)
              group_policy_id = try(meraki_network_group_policy.networks_group_policies[format("%s/%s/%s/%s", domain.name, organization.name, network.name, identity_psk.group_policy_name)].id, null)
              expires_at      = try(identity_psk.expires_at, local.defaults.meraki.domains.organizations.networks.wireless.ssids.identity_psks.expires_at, null)
            }
          ]
        ]
      ]
    ]
  ])
}

resource "meraki_wireless_ssid_identity_psk" "networks_wireless_ssids_identity_psks" {
  for_each        = { for v in local.networks_wireless_ssids_identity_psks : v.key => v }
  network_id      = each.value.network_id
  number          = each.value.number
  name            = each.value.name
  passphrase      = each.value.passphrase
  group_policy_id = each.value.group_policy_id
  expires_at      = each.value.expires_at
}

locals {
  networks_wireless_ssids_unavailability_schedules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for wireless_ssid in try(network.wireless.ssids, []) : {
            key        = format("%s/%s/%s/%s", domain.name, organization.name, network.name, wireless_ssid.name)
            network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
            number     = meraki_wireless_ssid.networks_wireless_ssids[format("%s/%s/%s/%s", domain.name, organization.name, network.name, wireless_ssid.name)].number
            enabled    = try(wireless_ssid.unavailability_schedules.enabled, local.defaults.meraki.domains.organizations.networks.wireless.ssids.unavailability_schedules.enabled, null)
            ranges = try(length(wireless_ssid.unavailability_schedules.ranges) == 0, true) ? null : [
              for range in try(wireless_ssid.unavailability_schedules.ranges, []) : {
                start_day  = try(range.start_day, local.defaults.meraki.domains.organizations.networks.wireless.ssids.unavailability_schedules.ranges.start_day, null)
                start_time = try(range.start_time, local.defaults.meraki.domains.organizations.networks.wireless.ssids.unavailability_schedules.ranges.start_time, null)
                end_day    = try(range.end_day, local.defaults.meraki.domains.organizations.networks.wireless.ssids.unavailability_schedules.ranges.end_day, null)
                end_time   = try(range.end_time, local.defaults.meraki.domains.organizations.networks.wireless.ssids.unavailability_schedules.ranges.end_time, null)
              }
            ]
            ranges_in_seconds = try(length(wireless_ssid.unavailability_schedules.ranges_in_seconds) == 0, true) ? null : [
              for ranges_in_second in try(wireless_ssid.unavailability_schedules.ranges_in_seconds, []) : {
                start = try(ranges_in_second.start, local.defaults.meraki.domains.organizations.networks.wireless.ssids.unavailability_schedules.ranges_in_seconds.start, null)
                end   = try(ranges_in_second.end, local.defaults.meraki.domains.organizations.networks.wireless.ssids.unavailability_schedules.ranges_in_seconds.end, null)
              }
            ]
          } if try(wireless_ssid.unavailability_schedules, null) != null
        ]
      ]
    ]
  ])
}

resource "meraki_wireless_ssid_schedules" "networks_wireless_ssids_unavailability_schedules" {
  for_each          = { for v in local.networks_wireless_ssids_unavailability_schedules : v.key => v }
  network_id        = each.value.network_id
  number            = each.value.number
  enabled           = each.value.enabled
  ranges            = each.value.ranges
  ranges_in_seconds = each.value.ranges_in_seconds
}

locals {
  networks_wireless_ssids_splash_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for wireless_ssid in try(network.wireless.ssids, []) : {
            key              = format("%s/%s/%s/%s", domain.name, organization.name, network.name, wireless_ssid.name)
            network_id       = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
            number           = meraki_wireless_ssid.networks_wireless_ssids[format("%s/%s/%s/%s", domain.name, organization.name, network.name, wireless_ssid.name)].number
            splash_url       = try(wireless_ssid.splash_settings.splash_url, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.splash_url, null)
            use_splash_url   = try(wireless_ssid.splash_settings.use_splash_url, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.use_splash_url, null)
            splash_timeout   = try(wireless_ssid.splash_settings.splash_timeout, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.splash_timeout, null)
            redirect_url     = try(wireless_ssid.splash_settings.redirect_url, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.redirect_url, null)
            use_redirect_url = try(wireless_ssid.splash_settings.use_redirect_url, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.use_redirect_url, null)
            welcome_message  = try(wireless_ssid.splash_settings.welcome_message, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.welcome_message, null)
            # TODO Map from theme_name when splash theme resource is implemented.
            theme_id                                      = try(wireless_ssid.splash_settings.theme_id, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.theme_id, null)
            splash_logo_md5                               = try(wireless_ssid.splash_settings.splash_logo.md5, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.splash_logo.md5, null)
            splash_logo_extension                         = try(wireless_ssid.splash_settings.splash_logo.extension, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.splash_logo.extension, null)
            splash_logo_image_format                      = try(wireless_ssid.splash_settings.splash_logo.image.format, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.splash_logo.image.format, null)
            splash_logo_image_contents                    = try(wireless_ssid.splash_settings.splash_logo.image.contents, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.splash_logo.image.contents, null)
            splash_image_md5                              = try(wireless_ssid.splash_settings.splash_image.md5, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.splash_image.md5, null)
            splash_image_extension                        = try(wireless_ssid.splash_settings.splash_image.extension, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.splash_image.extension, null)
            splash_image_image_format                     = try(wireless_ssid.splash_settings.splash_image.image.format, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.splash_image.image.format, null)
            splash_image_image_contents                   = try(wireless_ssid.splash_settings.splash_image.image.contents, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.splash_image.image.contents, null)
            splash_prepaid_front_md5                      = try(wireless_ssid.splash_settings.splash_prepaid_front.md5, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.splash_prepaid_front.md5, null)
            splash_prepaid_front_extension                = try(wireless_ssid.splash_settings.splash_prepaid_front.extension, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.splash_prepaid_front.extension, null)
            splash_prepaid_front_image_format             = try(wireless_ssid.splash_settings.splash_prepaid_front.image.format, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.splash_prepaid_front.image.format, null)
            splash_prepaid_front_image_contents           = try(wireless_ssid.splash_settings.splash_prepaid_front.image.contents, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.splash_prepaid_front.image.contents, null)
            block_all_traffic_before_sign_on              = try(wireless_ssid.splash_settings.block_all_traffic_before_sign_on, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.block_all_traffic_before_sign_on, null)
            controller_disconnection_behavior             = try(wireless_ssid.splash_settings.controller_disconnection_behavior, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.controller_disconnection_behavior, null)
            allow_simultaneous_logins                     = try(wireless_ssid.splash_settings.allow_simultaneous_logins, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.allow_simultaneous_logins, null)
            guest_sponsorship_duration_in_minutes         = try(wireless_ssid.splash_settings.guest_sponsorship.duration_in_minutes, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.guest_sponsorship.duration_in_minutes, null)
            guest_sponsorship_guest_can_request_timeframe = try(wireless_ssid.splash_settings.guest_sponsorship.guest_can_request_timeframe, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.guest_sponsorship.guest_can_request_timeframe, null)
            billing_free_access_enabled                   = try(wireless_ssid.splash_settings.billing.free_access.enabled, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.billing.free_access.enabled, null)
            billing_free_access_duration_in_minutes       = try(wireless_ssid.splash_settings.billing.free_access.duration_in_minutes, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.billing.free_access.duration_in_minutes, null)
            billing_prepaid_access_fast_login_enabled     = try(wireless_ssid.splash_settings.billing.prepaid_access_fast_login, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.billing.prepaid_access_fast_login, null)
            billing_reply_to_email_address                = try(wireless_ssid.splash_settings.billing.reply_to_email_address, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.billing.reply_to_email_address, null)
            sentry_enrollment_systems_manager_network_id  = try(local.network_ids[format("%s/%s/%s", domain.name, organization.name, wireless_ssid.splash_settings.sentry_enrollment.systems_manager_network)], null)
            sentry_enrollment_strength                    = try(wireless_ssid.splash_settings.sentry_enrollment.strength, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.sentry_enrollment.strength, null)
            sentry_enrollment_enforced_systems            = try(wireless_ssid.splash_settings.sentry_enrollment.enforced_systems, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.sentry_enrollment.enforced_systems, null)
            self_registration_enabled                     = try(wireless_ssid.splash_settings.self_registration.enabled, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.self_registration.enabled, null)
            self_registration_authorization_type          = try(wireless_ssid.splash_settings.self_registration.authorization_type, local.defaults.meraki.domains.organizations.networks.wireless.ssids.splash_settings.self_registration.authorization_type, null)
          } if try(wireless_ssid.splash_settings, null) != null
        ]
      ]
    ]
  ])
}

resource "meraki_wireless_ssid_splash_settings" "networks_wireless_ssids_splash_settings" {
  for_each                                      = { for v in local.networks_wireless_ssids_splash_settings : v.key => v }
  network_id                                    = each.value.network_id
  number                                        = each.value.number
  splash_url                                    = each.value.splash_url
  use_splash_url                                = each.value.use_splash_url
  splash_timeout                                = each.value.splash_timeout
  redirect_url                                  = each.value.redirect_url
  use_redirect_url                              = each.value.use_redirect_url
  welcome_message                               = each.value.welcome_message
  theme_id                                      = each.value.theme_id
  splash_logo_md5                               = each.value.splash_logo_md5
  splash_logo_extension                         = each.value.splash_logo_extension
  splash_logo_image_format                      = each.value.splash_logo_image_format
  splash_logo_image_contents                    = each.value.splash_logo_image_contents
  splash_image_md5                              = each.value.splash_image_md5
  splash_image_extension                        = each.value.splash_image_extension
  splash_image_image_format                     = each.value.splash_image_image_format
  splash_image_image_contents                   = each.value.splash_image_image_contents
  splash_prepaid_front_md5                      = each.value.splash_prepaid_front_md5
  splash_prepaid_front_extension                = each.value.splash_prepaid_front_extension
  splash_prepaid_front_image_format             = each.value.splash_prepaid_front_image_format
  splash_prepaid_front_image_contents           = each.value.splash_prepaid_front_image_contents
  block_all_traffic_before_sign_on              = each.value.block_all_traffic_before_sign_on
  controller_disconnection_behavior             = each.value.controller_disconnection_behavior
  allow_simultaneous_logins                     = each.value.allow_simultaneous_logins
  guest_sponsorship_duration_in_minutes         = each.value.guest_sponsorship_duration_in_minutes
  guest_sponsorship_guest_can_request_timeframe = each.value.guest_sponsorship_guest_can_request_timeframe
  billing_free_access_enabled                   = each.value.billing_free_access_enabled
  billing_free_access_duration_in_minutes       = each.value.billing_free_access_duration_in_minutes
  billing_prepaid_access_fast_login_enabled     = each.value.billing_prepaid_access_fast_login_enabled
  billing_reply_to_email_address                = each.value.billing_reply_to_email_address
  sentry_enrollment_systems_manager_network_id  = each.value.sentry_enrollment_systems_manager_network_id
  sentry_enrollment_strength                    = each.value.sentry_enrollment_strength
  sentry_enrollment_enforced_systems            = each.value.sentry_enrollment_enforced_systems
  self_registration_enabled                     = each.value.self_registration_enabled
  self_registration_authorization_type          = each.value.self_registration_authorization_type
}


locals {
  networks_wireless_ssids_traffic_shaping_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for wireless_ssid in try(network.wireless.ssids, []) : {
            key                     = format("%s/%s/%s/%s", domain.name, organization.name, network.name, wireless_ssid.name)
            network_id              = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
            number                  = meraki_wireless_ssid.networks_wireless_ssids[format("%s/%s/%s/%s", domain.name, organization.name, network.name, wireless_ssid.name)].number
            traffic_shaping_enabled = try(wireless_ssid.traffic_shaping_rules.traffic_shaping, local.defaults.meraki.domains.organizations.networks.wireless.ssids.traffic_shaping_rules.traffic_shaping, null)
            default_rules_enabled   = try(wireless_ssid.traffic_shaping_rules.default_rules, local.defaults.meraki.domains.organizations.networks.wireless.ssids.traffic_shaping_rules.default_rules, null)
            rules = try(length(wireless_ssid.traffic_shaping_rules.rules) == 0, true) ? null : [
              for rule in try(wireless_ssid.traffic_shaping_rules.rules, []) : {
                definitions = [
                  for definition in try(rule.definitions, []) : {
                    type  = try(definition.type, local.defaults.meraki.domains.organizations.networks.wireless.ssids.traffic_shaping_rules.rules.definitions.type, null)
                    value = try(definition.value, local.defaults.meraki.domains.organizations.networks.wireless.ssids.traffic_shaping_rules.rules.definitions.value, null)
                  }
                ]
                per_client_bandwidth_limits_settings                    = try(rule.per_client_bandwidth_limits.settings, local.defaults.meraki.domains.organizations.networks.wireless.ssids.traffic_shaping_rules.rules.per_client_bandwidth_limits.settings, null)
                per_client_bandwidth_limits_bandwidth_limits_limit_up   = try(rule.per_client_bandwidth_limits.bandwidth_limits.limit_up, local.defaults.meraki.domains.organizations.networks.wireless.ssids.traffic_shaping_rules.rules.per_client_bandwidth_limits.bandwidth_limits.limit_up, null)
                per_client_bandwidth_limits_bandwidth_limits_limit_down = try(rule.per_client_bandwidth_limits.bandwidth_limits.limit_down, local.defaults.meraki.domains.organizations.networks.wireless.ssids.traffic_shaping_rules.rules.per_client_bandwidth_limits.bandwidth_limits.limit_down, null)
                dscp_tag_value                                          = try(rule.dscp_tag_value, local.defaults.meraki.domains.organizations.networks.wireless.ssids.traffic_shaping_rules.rules.dscp_tag_value, null)
                pcp_tag_value                                           = try(rule.pcp_tag_value, local.defaults.meraki.domains.organizations.networks.wireless.ssids.traffic_shaping_rules.rules.pcp_tag_value, null)
              }
            ]
          } if try(wireless_ssid.traffic_shaping_rules, null) != null
        ]
      ]
    ]
  ])
}

resource "meraki_wireless_ssid_traffic_shaping_rules" "networks_wireless_ssids_traffic_shaping_rules" {
  for_each                = { for v in local.networks_wireless_ssids_traffic_shaping_rules : v.key => v }
  network_id              = each.value.network_id
  number                  = each.value.number
  traffic_shaping_enabled = each.value.traffic_shaping_enabled
  default_rules_enabled   = each.value.default_rules_enabled
  rules                   = each.value.rules
}


locals {
  networks_wireless_ssids_bonjour_forwarding = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for wireless_ssid in try(network.wireless.ssids, []) : {
            key        = format("%s/%s/%s/%s", domain.name, organization.name, network.name, wireless_ssid.name)
            network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
            number     = meraki_wireless_ssid.networks_wireless_ssids[format("%s/%s/%s/%s", domain.name, organization.name, network.name, wireless_ssid.name)].number
            enabled    = try(wireless_ssid.bonjour_forwarding.enabled, local.defaults.meraki.domains.organizations.networks.wireless.ssids.bonjour_forwarding.enabled, null)
            rules = try(length(wireless_ssid.bonjour_forwarding.rules) == 0, true) ? null : [
              for rule in try(wireless_ssid.bonjour_forwarding.rules, []) : {
                description = try(rule.description, local.defaults.meraki.domains.organizations.networks.wireless.ssids.bonjour_forwarding.rules.description, null)
                vlan_id     = try(rule.vlan_id, local.defaults.meraki.domains.organizations.networks.wireless.ssids.bonjour_forwarding.rules.vlan_id, null)
                services    = try(rule.services, local.defaults.meraki.domains.organizations.networks.wireless.ssids.bonjour_forwarding.rules.services, null)
              }
            ]
            exception_enabled = try(wireless_ssid.bonjour_forwarding.exception, local.defaults.meraki.domains.organizations.networks.wireless.ssids.bonjour_forwarding.exception, null)
          } if try(wireless_ssid.bonjour_forwarding, null) != null
        ]
      ]
    ]
  ])
}

resource "meraki_wireless_ssid_bonjour_forwarding" "networks_wireless_ssids_bonjour_forwarding" {
  for_each          = { for v in local.networks_wireless_ssids_bonjour_forwarding : v.key => v }
  network_id        = each.value.network_id
  number            = each.value.number
  enabled           = each.value.enabled
  rules             = each.value.rules
  exception_enabled = each.value.exception_enabled
}

locals {
  networks_wireless_alternate_management_interface = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          enabled    = try(network.wireless.alternate_management_interface.enabled, local.defaults.meraki.domains.organizations.networks.wireless.alternate_management_interface.enabled, null)
          vlan_id    = try(network.wireless.alternate_management_interface.vlan_id, local.defaults.meraki.domains.organizations.networks.wireless.alternate_management_interface.vlan_id, null)
          protocols  = try(network.wireless.alternate_management_interface.protocols, local.defaults.meraki.domains.organizations.networks.wireless.alternate_management_interface.protocols, null)
          access_points = try(length(network.wireless.alternate_management_interface.access_points) == 0, true) ? null : [
            for access_point in try(network.wireless.alternate_management_interface.access_points, []) : {
              serial                  = meraki_device.devices[format("%s/%s/%s/%s", domain.name, organization.name, network.name, access_point.device)].serial
              alternate_management_ip = try(access_point.alternate_management_ip, local.defaults.meraki.domains.organizations.networks.wireless.alternate_management_interface.access_points.alternate_management_ip, null)
              subnet_mask             = try(access_point.subnet_mask, local.defaults.meraki.domains.organizations.networks.wireless.alternate_management_interface.access_points.subnet_mask, null)
              gateway                 = try(access_point.gateway, local.defaults.meraki.domains.organizations.networks.wireless.alternate_management_interface.access_points.gateway, null)
              dns1                    = try(access_point.dns1, local.defaults.meraki.domains.organizations.networks.wireless.alternate_management_interface.access_points.dns1, null)
              dns2                    = try(access_point.dns2, local.defaults.meraki.domains.organizations.networks.wireless.alternate_management_interface.access_points.dns2, null)
            }
          ]
        } if try(network.wireless.alternate_management_interface, null) != null
      ]
    ]
  ])
}

resource "meraki_wireless_alternate_management_interface" "networks_wireless_alternate_management_interface" {
  for_each      = { for v in local.networks_wireless_alternate_management_interface : v.key => v }
  network_id    = each.value.network_id
  enabled       = each.value.enabled
  vlan_id       = each.value.vlan_id
  protocols     = each.value.protocols
  access_points = each.value.access_points
  depends_on = [
    meraki_wireless_ssid.networks_wireless_ssids,
  ]
}

locals {
  networks_wireless_bluetooth_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                         = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id                  = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          scanning_enabled            = try(network.wireless.bluetooth_settings.scanning, local.defaults.meraki.domains.organizations.networks.wireless.bluetooth_settings.scanning, null)
          advertising_enabled         = try(network.wireless.bluetooth_settings.advertising, local.defaults.meraki.domains.organizations.networks.wireless.bluetooth_settings.advertising, null)
          uuid                        = try(network.wireless.bluetooth_settings.uuid, local.defaults.meraki.domains.organizations.networks.wireless.bluetooth_settings.uuid, null)
          major_minor_assignment_mode = try(network.wireless.bluetooth_settings.major_minor_assignment_mode, local.defaults.meraki.domains.organizations.networks.wireless.bluetooth_settings.major_minor_assignment_mode, null)
          major                       = try(network.wireless.bluetooth_settings.major, local.defaults.meraki.domains.organizations.networks.wireless.bluetooth_settings.major, null)
          minor                       = try(network.wireless.bluetooth_settings.minor, local.defaults.meraki.domains.organizations.networks.wireless.bluetooth_settings.minor, null)
        } if try(network.wireless.bluetooth_settings, null) != null
      ]
    ]
  ])
}

resource "meraki_wireless_network_bluetooth_settings" "networks_wireless_bluetooth_settings" {
  for_each                    = { for v in local.networks_wireless_bluetooth_settings : v.key => v }
  network_id                  = each.value.network_id
  scanning_enabled            = each.value.scanning_enabled
  advertising_enabled         = each.value.advertising_enabled
  uuid                        = each.value.uuid
  major_minor_assignment_mode = each.value.major_minor_assignment_mode
  major                       = each.value.major
  minor                       = each.value.minor
  depends_on = [
    meraki_wireless_ssid.networks_wireless_ssids,
  ]
}

locals {
  networks_wireless_ssids_firewall_l7_firewall_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for wireless_ssid in try(network.wireless.ssids, []) : {
            key        = format("%s/%s/%s/%s", domain.name, organization.name, network.name, wireless_ssid.name)
            network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
            number     = meraki_wireless_ssid.networks_wireless_ssids[format("%s/%s/%s/%s", domain.name, organization.name, network.name, wireless_ssid.name)].number
            rules = try(length(wireless_ssid.firewall_l7_firewall_rules) == 0, true) ? null : [
              for firewall_l7_firewall_rule in try(wireless_ssid.firewall_l7_firewall_rules, []) : {
                policy = try(firewall_l7_firewall_rule.policy, local.defaults.meraki.domains.organizations.networks.wireless.ssids.firewall_l7_firewall_rules.policy, null)
                type   = try(firewall_l7_firewall_rule.type, local.defaults.meraki.domains.organizations.networks.wireless.ssids.firewall_l7_firewall_rules.type, null)
                value  = try(firewall_l7_firewall_rule.value, local.defaults.meraki.domains.organizations.networks.wireless.ssids.firewall_l7_firewall_rules.value, null)
              }
            ]
          } if try(wireless_ssid.firewall_l7_firewall_rules, null) != null
        ]
      ]
    ]
  ])
}

resource "meraki_wireless_ssid_l7_firewall_rules" "networks_wireless_ssids_firewall_l7_firewall_rules" {
  for_each   = { for v in local.networks_wireless_ssids_firewall_l7_firewall_rules : v.key => v }
  network_id = each.value.network_id
  number     = each.value.number
  rules      = each.value.rules
}
