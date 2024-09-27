locals {
  networks_group_policies = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for group_policy in try(network.group_policies, []) : {
            network_id = meraki_network.network["${domain.name}/${organization.name}/${network.name}"].id

            data = try(group_policy, null)
          } if try(network.group_policies, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_network_group_policy" "net_group_policies" {
  for_each   = { for i, v in local.networks_group_policies : i => v }
  network_id = each.value.network_id

  name = try(each.value.data.name, local.defaults.meraki.networks.group_policies.name, null)
  scheduling_enabled = try(each.value.data.scheduling.enabled, local.defaults.meraki.networks.group_policies.scheduling.enabled, null)
  scheduling_monday_active = try(each.value.data.scheduling.monday.active, local.defaults.meraki.networks.group_policies.scheduling.monday.active, null)
  scheduling_monday_from = try(each.value.data.scheduling.monday.from, local.defaults.meraki.networks.group_policies.scheduling.monday.from, null)
  scheduling_monday_to = try(each.value.data.scheduling.monday.to, local.defaults.meraki.networks.group_policies.scheduling.monday.to, null)
  scheduling_tuesday_active = try(each.value.data.scheduling.tuesday.active, local.defaults.meraki.networks.group_policies.scheduling.tuesday.active, null)
  scheduling_tuesday_from = try(each.value.data.scheduling.tuesday.from, local.defaults.meraki.networks.group_policies.scheduling.tuesday.from, null)
  scheduling_tuesday_to = try(each.value.data.scheduling.tuesday.to, local.defaults.meraki.networks.group_policies.scheduling.tuesday.to, null)
  scheduling_wednesday_active = try(each.value.data.scheduling.wednesday.active, local.defaults.meraki.networks.group_policies.scheduling.wednesday.active, null)
  scheduling_wednesday_from = try(each.value.data.scheduling.wednesday.from, local.defaults.meraki.networks.group_policies.scheduling.wednesday.from, null)
  scheduling_wednesday_to = try(each.value.data.scheduling.wednesday.to, local.defaults.meraki.networks.group_policies.scheduling.wednesday.to, null)
  scheduling_thursday_active = try(each.value.data.scheduling.thursday.active, local.defaults.meraki.networks.group_policies.scheduling.thursday.active, null)
  scheduling_thursday_from = try(each.value.data.scheduling.thursday.from, local.defaults.meraki.networks.group_policies.scheduling.thursday.from, null)
  scheduling_thursday_to = try(each.value.data.scheduling.thursday.to, local.defaults.meraki.networks.group_policies.scheduling.thursday.to, null)
  scheduling_friday_active = try(each.value.data.scheduling.friday.active, local.defaults.meraki.networks.group_policies.scheduling.friday.active, null)
  scheduling_friday_from = try(each.value.data.scheduling.friday.from, local.defaults.meraki.networks.group_policies.scheduling.friday.from, null)
  scheduling_friday_to = try(each.value.data.scheduling.friday.to, local.defaults.meraki.networks.group_policies.scheduling.friday.to, null)
  scheduling_saturday_active = try(each.value.data.scheduling.saturday.active, local.defaults.meraki.networks.group_policies.scheduling.saturday.active, null)
  scheduling_saturday_from = try(each.value.data.scheduling.saturday.from, local.defaults.meraki.networks.group_policies.scheduling.saturday.from, null)
  scheduling_saturday_to = try(each.value.data.scheduling.saturday.to, local.defaults.meraki.networks.group_policies.scheduling.saturday.to, null)
  scheduling_sunday_active = try(each.value.data.scheduling.sunday.active, local.defaults.meraki.networks.group_policies.scheduling.sunday.active, null)
  scheduling_sunday_from = try(each.value.data.scheduling.sunday.from, local.defaults.meraki.networks.group_policies.scheduling.sunday.from, null)
  scheduling_sunday_to = try(each.value.data.scheduling.sunday.to, local.defaults.meraki.networks.group_policies.scheduling.sunday.to, null)
  bandwidth_settings = try(each.value.data.bandwidth.settings, local.defaults.meraki.networks.group_policies.bandwidth.settings, null)
  bandwidth_limit_up = try(each.value.data.bandwidth.bandwidth_limits.limit_up, local.defaults.meraki.networks.group_policies.bandwidth.bandwidth_limits.limit_up, null)
  bandwidth_limit_down = try(each.value.data.bandwidth.bandwidth_limits.limit_down, local.defaults.meraki.networks.group_policies.bandwidth.bandwidth_limits.limit_down, null)
  firewall_and_traffic_shaping_settings = try(each.value.data.firewall_and_traffic_shaping.settings, local.defaults.meraki.networks.group_policies.firewall_and_traffic_shaping.settings, null)
  traffic_shaping_rules = try(each.value.data.firewall_and_traffic_shaping.traffic_shaping_rules, local.defaults.meraki.networks.group_policies.firewall_and_traffic_shaping.traffic_shaping_rules, null)
  l3_firewall_rules = try(each.value.data.firewall_and_traffic_shaping.l3_firewall_rules, local.defaults.meraki.networks.group_policies.firewall_and_traffic_shaping.l3_firewall_rules, null)
  l7_firewall_rules = try(each.value.data.firewall_and_traffic_shaping.l7_firewall_rules, local.defaults.meraki.networks.group_policies.firewall_and_traffic_shaping.l7_firewall_rules, null)
  content_filtering_allowed_url_patterns_settings = try(each.value.data.content_filtering.allowed_url_patterns.settings, local.defaults.meraki.networks.group_policies.content_filtering.allowed_url_patterns.settings, null)
  content_filtering_allowed_url_patterns = try(each.value.data.content_filtering.allowed_url_patterns.patterns, local.defaults.meraki.networks.group_policies.content_filtering.allowed_url_patterns.patterns, null)
  content_filtering_blocked_url_patterns_settings = try(each.value.data.content_filtering.blocked_url_patterns.settings, local.defaults.meraki.networks.group_policies.content_filtering.blocked_url_patterns.settings, null)
  content_filtering_blocked_url_patterns = try(each.value.data.content_filtering.blocked_url_patterns.patterns, local.defaults.meraki.networks.group_policies.content_filtering.blocked_url_patterns.patterns, null)
  content_filtering_blocked_url_categories_settings = try(each.value.data.content_filtering.blocked_url_categories.settings, local.defaults.meraki.networks.group_policies.content_filtering.blocked_url_categories.settings, null)
  content_filtering_blocked_url_categories = try(each.value.data.content_filtering.blocked_url_categories.categories, local.defaults.meraki.networks.group_policies.content_filtering.blocked_url_categories.categories, null)
  splash_auth_settings = try(each.value.data.splash_auth_settings, local.defaults.meraki.networks.group_policies.splash_auth_settings, null)
  vlan_tagging_settings = try(each.value.data.vlan_tagging.settings, local.defaults.meraki.networks.group_policies.vlan_tagging.settings, null)
  vlan_tagging_vlan_id = try(each.value.data.vlan_tagging.vlan_id, local.defaults.meraki.networks.group_policies.vlan_tagging.vlan_id, null)
  bonjour_forwarding_settings = try(each.value.data.bonjour_forwarding.settings, local.defaults.meraki.networks.group_policies.bonjour_forwarding.settings, null)
  bonjour_forwarding_rules = try(each.value.data.bonjour_forwarding.rules, local.defaults.meraki.networks.group_policies.bonjour_forwarding.rules, null)

}


locals {
  networks_settings = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${domain.name}/${organization.name}/${network.name}"].id

          data = try(network.settings, null)
        } if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_network_settings" "net_settings" {
  for_each   = { for i, v in local.networks_settings : i => v }
  network_id = each.value.network_id

  local_status_page_enabled = try(each.value.data.local_status_page_enabled, local.defaults.meraki.networks.settings.local_status_page_enabled, null)
  remote_status_page_enabled = try(each.value.data.remote_status_page_enabled, local.defaults.meraki.networks.settings.remote_status_page_enabled, null)
  local_status_page_authentication_enabled = try(each.value.data.local_status_page.authentication.enabled, local.defaults.meraki.networks.settings.local_status_page.authentication.enabled, null)
  local_status_page_authentication_password = try(each.value.data.local_status_page.authentication.password, local.defaults.meraki.networks.settings.local_status_page.authentication.password, null)
  secure_port_enabled = try(each.value.data.secure_port.enabled, local.defaults.meraki.networks.settings.secure_port.enabled, null)
  named_vlans_enabled = try(each.value.data.named_vlans.enabled, local.defaults.meraki.networks.settings.named_vlans.enabled, null)

}

locals {
  networks_snmp = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${domain.name}/${organization.name}/${network.name}"].id

          data = try(network.snmp, null)
        } if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_network_snmp" "net_snmp" {
  for_each   = { for i, v in local.networks_snmp : i => v }
  network_id = each.value.network_id

  access = try(each.value.data.access, local.defaults.meraki.networks.snmp.access, null)
  community_string = try(each.value.data.community_string, local.defaults.meraki.networks.snmp.community_string, null)
  users = try(each.value.data.users, local.defaults.meraki.networks.snmp.users, null)

}

# Consider Depends on logic for the following resource
# May split this so we have a depends on if switches are claimed
#  and then duplicate this for wireless or securtiy appliances etc
#  For example meraki_networks_devices_claim "net_device_switches" "net_device_wireless"
  
# resource "meraki_networks_devices_claim" "net_device_claims" {
#   for_each   = { for i, v in local.networks_switch_serials : i => v }
#   network_id = each.value.network_id
#   parameters = {
#     serials = each.value.data
#     }
# }
locals {
  networks_syslog_servers = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${domain.name}/${organization.name}/${network.name}"].id

          data = try(network.syslog_servers, null)
        } if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_network_syslog_servers" "net_syslog_servers" {
  for_each   = { for i, v in local.networks_syslog_servers : i => v }
  network_id = each.value.network_id

  servers = try(each.value.data.servers, local.defaults.meraki.networks.syslog_servers.servers, [])

}

locals {
  networks_vlan_profiles = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for vlan_profile in try(network.vlan_profiles, []) : {
            network_id = meraki_network.network["${domain.name}/${organization.name}/${network.name}"].id

            data = try(vlan_profile, null)
          } if try(network.vlan_profiles, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_network_vlan_profile" "net_vlan_profiles" {
  for_each   = { for i, v in local.networks_vlan_profiles : i => v }
  network_id = each.value.network_id

  iname = each.value.data.iname
  name = try(each.value.data.name, local.defaults.meraki.networks.vlan_profiles.name, null)
  vlan_names = try(each.value.data.vlan_names, local.defaults.meraki.networks.vlan_profiles.vlan_names, [])
  vlan_groups = try(each.value.data.vlan_groups, local.defaults.meraki.networks.vlan_profiles.vlan_groups, [])

}

locals {
  networks_networks_device_claims = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${domain.name}/${organization.name}/${network.name}"].id

          data = network.device_claim
        } if try(network.device_claim, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_network_device_claim" "net_device_claim" {
  for_each   = { for i, v in local.networks_networks_device_claims : i => v }
  network_id = each.value.network_id

  serials = try(each.value.data.serials, local.defaults.meraki.networks.networks_switch_stacks.serials, null)

}