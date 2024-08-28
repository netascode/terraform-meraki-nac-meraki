
// All resources and data sources are reliant on the meraki_networks data source and are reffered to via variable network_id
locals {
  networks_group_policies = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : [
          for group_policy in try(network.group_policies, []) : {
            network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
            data       = group_policy
          }
        ] if try(network.group_policies, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_group_policies" "net_group_policies" {
  for_each                     = { for i, v in local.networks_group_policies : i => v }
  network_id                   = each.value.network_id
  bandwidth                    = try(each.value.data.bandwidth, local.defaults.meraki.networks.group_policies.bandwidth, null)
  bonjour_forwarding           = try(each.value.data.bonjour_forwarding, local.defaults.meraki.networks.group_policies.bonjour_forwarding, null)
  content_filtering            = try(each.value.data.content_filtering, local.defaults.meraki.networks.group_policies.content_filtering, null)
  firewall_and_traffic_shaping = try(each.value.data.firewall_and_traffic_shaping, local.defaults.meraki.networks.group_policies.firewall_and_traffic_shaping, null)
  name                         = try(each.value.data.name, local.defaults.meraki.networks.group_policies.name, null)
  scheduling                   = try(each.value.data.scheduling, local.defaults.meraki.networks.group_policies.scheduling, null)
  splash_auth_settings         = try(each.value.data.splash_auth_settings, local.defaults.meraki.networks.group_policies.splash_auth_settings, null)
  vlan_tagging                 = try(each.value.data.vlan_tagging, local.defaults.meraki.networks.group_policies.vlan_tagging, null)
}

locals {
  networks_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = try(network.settings, {})
        } if try(network.settings, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_settings" "net_settings" {
  for_each   = { for i, v in local.networks_settings : i => v }
  network_id = each.value.network_id
  # fips = try(each.value.data.fips, null)
  local_status_page          = try(each.value.data.local_status_page, local.defaults.meraki.networks.networks_settings.local_status_page, null)
  local_status_page_enabled  = try(each.value.data.local_status_page_enabled, local.defaults.meraki.networks.networks_settings.local_status_page_enabled, null)
  named_vlans                = try(each.value.data.named_vlans, local.defaults.meraki.networks.networks_settings.named_vlans, null)
  remote_status_page_enabled = try(each.value.data.remote_status_page_enabled, local.defaults.meraki.networks.networks_settings.remote_status_page_enabled, null)
  secure_port                = try(each.value.data.secure_port, local.defaults.meraki.networks.networks_settings.secure_port, null)
}

locals {
  networks_switch_serials = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = network.switch_serials
        } if try(network.switch_serials, null) != null
      ]
    ]
  ])
  marcin_debug = 5#local.networks_switch_serials.data
}

# Consider Depends on logic for the following resource
# May split this so we have a depends on if switches are claimed
#  and then duplicate this for wireless or securtiy appliances etc
#  For example meraki_networks_devices_claim "net_device_switches" "net_device_wireless"
  
resource "meraki_networks_devices_claim" "net_device_claims" {
  for_each   = { for i, v in local.networks_switch_serials : i => v }
  network_id = each.value.network_id
  parameters = {
    serials = each.value.data
    }
}

locals {
  networks_syslog_servers = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = network.syslog_servers
        } if try(network.syslog_servers, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_syslog_servers" "net_syslog_servers" {
  for_each   = { for i, v in local.networks_syslog_servers : i => v }
  network_id = each.value.network_id
  servers    = try(each.value.data.servers, local.defaults.meraki.networks.syslog_servers.servers, null)
}

locals {
  networks_vlan_profiles = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : [
          for vlan_profile in try(network.vlan_profiles, []) : {
            network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
            data       = vlan_profile
          }
        ] if try(network.vlan_profiles, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_vlan_profiles" "net_vlan_profiles" {
  for_each   = { for i, v in local.networks_vlan_profiles : i => v }
  network_id = each.value.network_id
  iname      = try(each.value.data.iname, local.defaults.meraki.networks.vlan_profiles.iname, null)
  # is_default = try(each.value.data.is_default, local.defaults.meraki.networks.vlan_profiles.is_default, null)
  name        = try(each.value.data.name, local.defaults.meraki.networks.vlan_profiles.name, null)
  vlan_groups = try(each.value.data.vlan_groups, local.defaults.meraki.networks.vlan_profiles.vlan_groups, null)
  vlan_names  = try(each.value.data.vlan_names, local.defaults.meraki.networks.vlan_profiles.vlan_names, null)
}




