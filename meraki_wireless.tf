locals {
  networks_wireless_rf_profiles = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : [
          for wireless_rf_profile in try(network.wireless_rf_profiles, []) : {
            network_id     = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
            rf_profile_key = format("%s/%s/%s/wireless_rf_profiles/%s", domain.name, org.name, network.name, wireless_rf_profile.name)
            data           = wireless_rf_profile
          }
        ] if try(network.wireless_rf_profiles, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_wireless_rf_profiles" "net_wireless_rf_profiles" {
  for_each                 = { for i, v in local.networks_wireless_rf_profiles : i => v }
  network_id               = each.value.network_id
  ap_band_settings         = try(each.value.data.ap_band_settings, local.defaults.meraki.networks.wireless_rf_profiles.ap_band_settings, null)
  band_selection_type      = try(each.value.data.band_selection_type, local.defaults.meraki.networks.wireless_rf_profiles.band_selection_type, null)
  client_balancing_enabled = try(each.value.data.client_balancing_enabled, local.defaults.meraki.networks.wireless_rf_profiles.client_balancing_enabled, null)
  five_ghz_settings        = try(each.value.data.five_ghz_settings, local.defaults.meraki.networks.wireless_rf_profiles.five_ghz_settings, null)
  flex_radios              = try(each.value.data.flex_radios, local.defaults.meraki.networks.wireless_rf_profiles.flex_radios, null)
  min_bitrate_type         = try(each.value.data.min_bitrate_type, local.defaults.meraki.networks.wireless_rf_profiles.min_bitrate_type, null)
  name                     = try(each.value.data.name, local.defaults.meraki.networks.wireless_rf_profiles.name, null)
  per_ssid_settings        = try(each.value.data.per_ssid_settings, local.defaults.meraki.networks.wireless_rf_profiles.per_ssid_settings, null)
  rf_profile_id            = try(each.value.data.rf_profile_id, local.defaults.meraki.networks.wireless_rf_profiles.rf_profile_id, null)
  six_ghz_settings         = try(each.value.data.six_ghz_settings, local.defaults.meraki.networks.wireless_rf_profiles.six_ghz_settings, null)
  transmission             = try(each.value.data.transmission, local.defaults.meraki.networks.wireless_rf_profiles.transmission, null)
  two_four_ghz_settings    = try(each.value.data.two_four_ghz_settings, local.defaults.meraki.networks.wireless_rf_profiles.two_four_ghz_settings, null)
}

locals {
  networks_wireless_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = network.wireless_settings
        } if try(network.wireless_settings, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_wireless_settings" "net_wireless_settings" {
  for_each                   = { for i, v in local.networks_wireless_settings : i => v }
  network_id                 = each.value.network_id
  ipv6_bridge_enabled        = try(each.value.data.ipv6_bridge_enabled, local.defaults.meraki.networks.wireless_settings.ipv6_bridge_enabled, null)
  led_lights_on              = try(each.value.data.led_lights_on, local.defaults.meraki.networks.wireless_settings.led_lights_on, null)
  location_analytics_enabled = try(each.value.data.location_analytics_enabled, local.defaults.meraki.networks.wireless_settings.location_analytics_enabled, null)
  meshing_enabled            = try(each.value.data.meshing_enabled, local.defaults.meraki.networks.wireless_settings.meshing_enabled, null)
  named_vlans                = try(each.value.data.named_vlans, local.defaults.meraki.networks.wireless_settings.named_vlans, null)
  # regulatory_domain = try(each.value.data.regulatory_domain, local.defaults.meraki.networks.wireless_settings.regulatory_domain, null)
  upgradestrategy = try(each.value.data.upgradestrategy, local.defaults.meraki.networks.wireless_settings.upgradestrategy, null)
}

locals {
  networks_wireless_ssids = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : [
          for wireless_ssid in try(network.wireless_ssids, []) : {
            wireless_ssid_key = format("%s/%s/%s/wireless_ssids/%s", domain.name, org.name, network.name, wireless_ssid.name)
            data              = wireless_ssid
            network_id        = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          }
        ] if try(network.wireless_ssids, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_wireless_ssids" "net_wireless_ssids" {
  for_each         = { for i, v in local.networks_wireless_ssids : i => v }
  network_id       = each.value.network_id
  number           = each.key
  active_directory = try(each.value.data.active_directory, local.defaults.meraki.networks.wireless_ssids.active_directory, null)
  # admin_splash_url = try(each.value.data.admin_splash_url, local.defaults.meraki.networks.wireless_ssids.admin_splash_url, null)
  adult_content_filtering_enabled      = try(each.value.data.adult_content_filtering_enabled, local.defaults.meraki.networks.wireless_ssids.adult_content_filtering_enabled, null)
  ap_tags_and_vlan_ids                 = try(each.value.data.ap_tags_and_vlan_ids, local.defaults.meraki.networks.wireless_ssids.ap_tags_and_vlan_ids, null)
  auth_mode                            = try(each.value.data.auth_mode, local.defaults.meraki.networks.wireless_ssids.auth_mode, null)
  availability_tags                    = try(each.value.data.availability_tags, local.defaults.meraki.networks.wireless_ssids.availability_tags, null)
  available_on_all_aps                 = try(each.value.data.available_on_all_aps, local.defaults.meraki.networks.wireless_ssids.available_on_all_aps, null)
  band_selection                       = try(each.value.data.band_selection, local.defaults.meraki.networks.wireless_ssids.band_selection, null)
  concentrator_network_id              = try(each.value.data.concentrator_network_id, local.defaults.meraki.networks.wireless_ssids.concentrator_network_id, null)
  default_vlan_id                      = try(each.value.data.default_vlan_id, local.defaults.meraki.networks.wireless_ssids.default_vlan_id, null)
  disassociate_clients_on_vpn_failover = try(each.value.data.disassociate_clients_on_vpn_failover, local.defaults.meraki.networks.wireless_ssids.disassociate_clients_on_vpn_failover, null)
  dns_rewrite                          = try(each.value.data.dns_rewrite, local.defaults.meraki.networks.wireless_ssids.dns_rewrite, null)
  dot11r                               = try(each.value.data.dot11r, local.defaults.meraki.networks.wireless_ssids.dot11r, null)
  dot11w                               = try(each.value.data.dot11w, local.defaults.meraki.networks.wireless_ssids.dot11w, null)
  enabled                              = try(each.value.data.enabled, local.defaults.meraki.networks.wireless_ssids.enabled, null)
  encryption_mode                      = try(each.value.data.encryption_mode, local.defaults.meraki.networks.wireless_ssids.encryption_mode, null)
  enterprise_admin_access              = try(each.value.data.enterprise_admin_access, local.defaults.meraki.networks.wireless_ssids.enterprise_admin_access, null)
  gre                                  = try(each.value.data.gre, local.defaults.meraki.networks.wireless_ssids.gre, null)
  ip_assignment_mode                   = try(each.value.data.ip_assignment_mode, local.defaults.meraki.networks.wireless_ssids.ip_assignment_mode, null)
  lan_isolation_enabled                = try(each.value.data.lan_isolation_enabled, local.defaults.meraki.networks.wireless_ssids.lan_isolation_enabled, null)
  ldap                                 = try(each.value.data.ldap, local.defaults.meraki.networks.wireless_ssids.ldap, null)
  # local_auth = try(each.value.data.local_auth, local.defaults.meraki.networks.wireless_ssids.local_auth, null)
  local_radius                        = try(each.value.data.local_radius, local.defaults.meraki.networks.wireless_ssids.local_radius, null)
  mandatory_dhcp_enabled              = try(each.value.data.mandatory_dhcp_enabled, local.defaults.meraki.networks.wireless_ssids.mandatory_dhcp_enabled, null)
  min_bitrate                         = try(each.value.data.min_bitrate, local.defaults.meraki.networks.wireless_ssids.min_bitrate, null)
  name                                = try(each.value.data.name, local.defaults.meraki.networks.wireless_ssids.name, null)
  named_vlans                         = try(each.value.data.named_vlans, local.defaults.meraki.networks.wireless_ssids.named_vlans, null)
  oauth                               = try(each.value.data.oauth, local.defaults.meraki.networks.wireless_ssids.oauth, null)
  per_client_bandwidth_limit_down     = try(each.value.data.per_client_bandwidth_limit_down, local.defaults.meraki.networks.wireless_ssids.per_client_bandwidth_limit_down, null)
  per_client_bandwidth_limit_up       = try(each.value.data.per_client_bandwidth_limit_up, local.defaults.meraki.networks.wireless_ssids.per_client_bandwidth_limit_up, null)
  per_ssid_bandwidth_limit_down       = try(each.value.data.per_ssid_bandwidth_limit_down, local.defaults.meraki.networks.wireless_ssids.per_ssid_bandwidth_limit_down, null)
  per_ssid_bandwidth_limit_up         = try(each.value.data.per_ssid_bandwidth_limit_up, local.defaults.meraki.networks.wireless_ssids.per_ssid_bandwidth_limit_up, null)
  psk                                 = try(each.value.data.psk, local.defaults.meraki.networks.wireless_ssids.psk, null)
  radius_accounting_enabled           = try(each.value.data.radius_accounting_enabled, local.defaults.meraki.networks.wireless_ssids.radius_accounting_enabled, null)
  radius_accounting_interim_interval  = try(each.value.data.radius_accounting_interim_interval, local.defaults.meraki.networks.wireless_ssids.radius_accounting_interim_interval, null)
  radius_accounting_servers           = try(each.value.data.radius_accounting_servers, local.defaults.meraki.networks.wireless_ssids.radius_accounting_servers, null)
  radius_attribute_for_group_policies = try(each.value.data.radius_attribute_for_group_policies, local.defaults.meraki.networks.wireless_ssids.radius_attribute_for_group_policies, null)
  radius_authentication_nas_id        = try(each.value.data.radius_authentication_nas_id, local.defaults.meraki.networks.wireless_ssids.radius_authentication_nas_id, null)
  radius_called_station_id            = try(each.value.data.radius_called_station_id, local.defaults.meraki.networks.wireless_ssids.radius_called_station_id, null)
  radius_coa_enabled                  = try(each.value.data.radius_coa_enabled, local.defaults.meraki.networks.wireless_ssids.radius_coa_enabled, null)
  # radius_enabled = try(each.value.data.radius_enabled, local.defaults.meraki.networks.wireless_ssids.radius_enabled, null)
  radius_failover_policy       = try(each.value.data.radius_failover_policy, local.defaults.meraki.networks.wireless_ssids.radius_failover_policy, null)
  radius_fallback_enabled      = try(each.value.data.radius_fallback_enabled, local.defaults.meraki.networks.wireless_ssids.radius_fallback_enabled, null)
  radius_guest_vlan_enabled    = try(each.value.data.radius_guest_vlan_enabled, local.defaults.meraki.networks.wireless_ssids.radius_guest_vlan_enabled, null)
  radius_guest_vlan_id         = try(each.value.data.radius_guest_vlan_id, local.defaults.meraki.networks.wireless_ssids.radius_guest_vlan_id, null)
  radius_load_balancing_policy = try(each.value.data.radius_load_balancing_policy, local.defaults.meraki.networks.wireless_ssids.radius_load_balancing_policy, null)
  radius_override              = try(each.value.data.radius_override, local.defaults.meraki.networks.wireless_ssids.radius_override, null)
  radius_proxy_enabled         = try(each.value.data.radius_proxy_enabled, local.defaults.meraki.networks.wireless_ssids.radius_proxy_enabled, null)
  radius_server_attempts_limit = try(each.value.data.radius_server_attempts_limit, local.defaults.meraki.networks.wireless_ssids.radius_server_attempts_limit, null)
  radius_server_timeout        = try(each.value.data.radius_server_timeout, local.defaults.meraki.networks.wireless_ssids.radius_server_timeout, null)
  radius_servers               = try(each.value.data.radius_servers, local.defaults.meraki.networks.wireless_ssids.radius_servers, null)
  # radius_servers_response = try(each.value.data.radius_servers_response, local.defaults.meraki.networks.wireless_ssids.radius_servers_response, null)
  radius_testing_enabled            = try(each.value.data.radius_testing_enabled, local.defaults.meraki.networks.wireless_ssids.radius_testing_enabled, null)
  secondary_concentrator_network_id = try(each.value.data.secondary_concentrator_network_id, local.defaults.meraki.networks.wireless_ssids.secondary_concentrator_network_id, null)
  speed_burst                       = try(each.value.data.speed_burst, local.defaults.meraki.networks.wireless_ssids.speed_burst, null)
  splash_guest_sponsor_domains      = try(each.value.data.splash_guest_sponsor_domains, local.defaults.meraki.networks.wireless_ssids.splash_guest_sponsor_domains, null)
  splash_page                       = try(each.value.data.splash_page, local.defaults.meraki.networks.wireless_ssids.splash_page, null)
  # splash_timeout = try(each.value.data.splash_timeout, local.defaults.meraki.networks.wireless_ssids.splash_timeout, null)
  # ssid_admin_accessible = try(each.value.data.ssid_admin_accessible, local.defaults.meraki.networks.wireless_ssids.ssid_admin_accessible, null)
  use_vlan_tagging      = try(each.value.data.use_vlan_tagging, local.defaults.meraki.networks.wireless_ssids.use_vlan_tagging, null)
  visible               = try(each.value.data.visible, local.defaults.meraki.networks.wireless_ssids.visible, null)
  vlan_id               = try(each.value.data.vlan_id, local.defaults.meraki.networks.wireless_ssids.vlan_id, null)
  walled_garden_enabled = try(each.value.data.walled_garden_enabled, local.defaults.meraki.networks.wireless_ssids.walled_garden_enabled, null)
  walled_garden_ranges  = try(each.value.data.walled_garden_ranges, local.defaults.meraki.networks.wireless_ssids.walled_garden_ranges, null)
  wpa_encryption_mode   = try(each.value.data.wpa_encryption_mode, local.defaults.meraki.networks.wireless_ssids.wpa_encryption_mode, null)
}
