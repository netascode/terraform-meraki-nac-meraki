locals {
  networks_networks_appliance_content_filtering = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance_content_filtering, null)
        } if try(network.appliance_content_filtering, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_content_filtering" "appliance_content_filtering" {
  for_each               = { for i, v in local.networks_networks_appliance_content_filtering : i => v }
  network_id             = each.value.network_id
  allowed_url_patterns   = try(each.value.data.allowed_url_patterns, local.defaults.meraki.networks.appliance_content_filtering.allowed_url_patterns, null)
  blocked_url_patterns   = try(each.value.data.blocked_url_patterns, local.defaults.meraki.networks.appliance_content_filtering.blocked_url_patterns, null)
  blocked_url_categories = try(each.value.data.blocked_url_categories, local.defaults.meraki.networks.appliance_content_filtering.blocked_url_categories, null)
  url_category_list_size = try(each.value.data.url_category_list_size, local.defaults.meraki.networks.appliance_content_filtering.url_category_list_size, null)

}

locals {
  networks_networks_appliance_firewall_firewalled_services = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for appliance_firewall_firewalled_service in try(network.appliance_firewall_firewalled_services, []) : {
            network_id = meraki_network.network["${organization.name}/${network.name}"].id
            data       = try(appliance_firewall_firewalled_service, null)
          }
        ] if try(network.appliance_firewall_firewalled_services, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_firewalled_service" "appliance_firewall_firewalled_services" {
  for_each    = { for i, v in local.networks_networks_appliance_firewall_firewalled_services : i => v }
  network_id  = each.value.network_id
  access      = try(each.value.data.access, local.defaults.meraki.networks.appliance_firewall_firewalled_services.access, null)
  allowed_ips = try(each.value.data.allowed_ips, local.defaults.meraki.networks.appliance_firewall_firewalled_services.allowed_ips, null)
  service     = each.value.data.service_name

}

locals {
  networks_networks_appliance_firewall_inbound_firewall_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance_firewall_inbound_firewall_rules, null)
          rules = [for r in network.appliance_firewall_inbound_firewall_rules.rules : merge(r,
            {
              dest_cidr = try(r.destination_cidr, null)
              dest_port = try(r.destination_port, null)
              src_cidr  = try(r.source_cidr, null)
              src_port  = try(r.source_port, null)
            }
          )]
        } if try(network.appliance_firewall_inbound_firewall_rules, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_inbound_firewall_rules" "appliance_firewall_inbound_firewall_rules" {
  for_each            = { for i, v in local.networks_networks_appliance_firewall_inbound_firewall_rules : i => v }
  network_id          = each.value.network_id
  rules               = length(each.value.rules) > 0 ? each.value.rules : null
  syslog_default_rule = try(each.value.data.syslog_default_rule, local.defaults.meraki.networks.appliance_firewall_inbound_firewall_rules.syslog_default_rule, null)

}

locals {
  networks_networks_appliance_firewall_l3_firewall_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance_firewall_l3_firewall_rules, null)
        } if try(network.appliance_firewall_l3_firewall_rules, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_l3_firewall_rules" "appliance_firewall_l3_firewall_rules" {
  for_each            = { for i, v in local.networks_networks_appliance_firewall_l3_firewall_rules : i => v }
  network_id          = each.value.network_id
  rules               = try(each.value.data.rules, local.defaults.meraki.networks.appliance_firewall_l3_firewall_rules.rules, null)
  syslog_default_rule = try(each.value.data.syslog_default_rule, local.defaults.meraki.networks.appliance_firewall_l3_firewall_rules.syslog_default_rule, null)
}

locals {
  networks_networks_appliance_firewall_l7_firewall_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance_firewall_l7_firewall_rules, null)
        } if try(network.appliance_firewall_l7_firewall_rules, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_l7_firewall_rules" "appliance_firewall_l7_firewall_rules" {
  for_each   = { for i, v in local.networks_networks_appliance_firewall_l7_firewall_rules : i => v }
  network_id = each.value.network_id
  rules      = try(each.value.data.rules, local.defaults.meraki.networks.appliance_firewall_l7_firewall_rules.rules, null)
}

locals {
  networks_networks_appliance_firewall_one_to_many_nat_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance_firewall_one_to_many_nat_rules, null)
        } if try(network.appliance_firewall_one_to_many_nat_rules, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_one_to_many_nat_rules" "appliance_firewall_one_to_many_nat_rules" {
  for_each   = { for i, v in local.networks_networks_appliance_firewall_one_to_many_nat_rules : i => v }
  network_id = each.value.network_id
  rules      = try(each.value.data.rules, local.defaults.meraki.networks.appliance_firewall_one_to_many_nat_rules.rules, null)
}

locals {
  networks_networks_appliance_firewall_one_to_one_nat_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance_firewall_one_to_one_nat_rules, null)
        } if try(network.appliance_firewall_one_to_one_nat_rules, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_one_to_one_nat_rules" "appliance_firewall_one_to_one_nat_rules" {
  for_each   = { for i, v in local.networks_networks_appliance_firewall_one_to_one_nat_rules : i => v }
  network_id = each.value.network_id
  rules      = try(each.value.data.rules, local.defaults.meraki.networks.appliance_firewall_one_to_one_nat_rules.rules, null)
}

locals {
  networks_networks_appliance_firewall_port_forwarding_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance_firewall_port_forwarding_rules, null)
        } if try(network.appliance_firewall_port_forwarding_rules, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_port_forwarding_rules" "appliance_firewall_port_forwarding_rules" {
  for_each   = { for i, v in local.networks_networks_appliance_firewall_port_forwarding_rules : i => v }
  network_id = each.value.network_id
  rules      = try(each.value.data.rules, local.defaults.meraki.networks.appliance_firewall_port_forwarding_rules.rules, null)
}

locals {
  networks_networks_appliance_firewall_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance_firewall_settings, null)
        } if try(network.appliance_firewall_settings, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_firewall_settings" "appliance_firewall_settings" {
  for_each                                 = { for i, v in local.networks_networks_appliance_firewall_settings : i => v }
  network_id                               = each.value.network_id
  spoofing_protection_ip_source_guard_mode = try(each.value.data.spoofing_protection.ip_source_guard.mode, local.defaults.meraki.networks.appliance_firewall_settings.spoofing_protection.ip_source_guard.mode, null)
}

locals {
  networks_networks_appliance_ports = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for appliance_port in try(network.appliance_ports, []) : {
            network_id = meraki_network.network["${organization.name}/${network.name}"].id
            data       = try(appliance_port, null)
          } if try(network.appliance_ports, null) != null
        ] if try(network.appliance_ports, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_port" "appliance_ports" {
  for_each              = { for i, v in local.networks_networks_appliance_ports : i => v }
  network_id            = each.value.network_id
  enabled               = try(each.value.data.enabled, local.defaults.meraki.networks.appliance_ports.enabled, null)
  drop_untagged_traffic = try(each.value.data.drop_untagged_traffic, local.defaults.meraki.networks.appliance_ports.drop_untagged_traffic, null)
  type                  = try(each.value.data.type, local.defaults.meraki.networks.appliance_ports.type, null)
  vlan                  = try(each.value.data.vlan, local.defaults.meraki.networks.appliance_ports.vlan, null)
  allowed_vlans         = try(each.value.data.allowed_vlans, local.defaults.meraki.networks.appliance_ports.allowed_vlans, null)
  access_policy         = try(each.value.data.access_policy, local.defaults.meraki.networks.appliance_ports.access_policy, null)
  port_id               = each.value.data.port_id
}
locals {
  networks_networks_appliance_security_intrusion = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance_security_intrusion, null)
        } if try(network.appliance_security_intrusion, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_network_security_intrusion" "appliance_security_intrusion" {
  for_each                         = { for i, v in local.networks_networks_appliance_security_intrusion : i => v }
  network_id                       = each.value.network_id
  mode                             = try(each.value.data.mode, local.defaults.meraki.networks.appliance_security_intrusion.mode, null)
  ids_rulesets                     = try(each.value.data.ids_rulesets, local.defaults.meraki.networks.appliance_security_intrusion.ids_rulesets, null)
  protected_networks_use_default   = try(each.value.data.protected_networks.use_default, local.defaults.meraki.networks.appliance_security_intrusion.protected_networks.use_default, null)
  protected_networks_included_cidr = try(each.value.data.protected_networks.included_cidr, local.defaults.meraki.networks.appliance_security_intrusion.protected_networks.included_cidr, null)
  protected_networks_excluded_cidr = try(each.value.data.protected_networks.excluded_cidr, local.defaults.meraki.networks.appliance_security_intrusion.protected_networks.excluded_cidr, null)
}
locals {
  networks_networks_appliance_security_malware = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance_security_malware, null)
        } if try(network.appliance_security_malware, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_security_malware" "appliance_security_malware" {
  for_each      = { for i, v in local.networks_networks_appliance_security_malware : i => v }
  network_id    = each.value.network_id
  mode          = try(each.value.data.mode, local.defaults.meraki.networks.appliance_security_malware.mode, null)
  allowed_urls  = try(each.value.data.allowed_urls, local.defaults.meraki.networks.appliance_security_malware.allowed_urls, null)
  allowed_files = try(each.value.data.allowed_files, local.defaults.meraki.networks.appliance_security_malware.allowed_files, null)
}

locals {
  networks_networks_appliance_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance_settings, null)
        } if try(network.appliance_settings, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_settings" "appliance_settings" {
  for_each               = { for i, v in local.networks_networks_appliance_settings : i => v }
  network_id             = each.value.network_id
  client_tracking_method = try(each.value.data.client_tracking_method, local.defaults.meraki.networks.appliance_settings.client_tracking_method, null)
  deployment_mode        = try(each.value.data.deployment_mode, local.defaults.meraki.networks.appliance_settings.deployment_mode, null)
  dynamic_dns_prefix     = try(each.value.data.dynamic_dns.prefix, local.defaults.meraki.networks.appliance_settings.dynamic_dns.prefix, null)
  dynamic_dns_enabled    = try(each.value.data.dynamic_dns.enabled, local.defaults.meraki.networks.appliance_settings.dynamic_dns.enabled, null)
}
locals {
  networks_networks_appliance_single_lan = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance_single_lan, null)
        } if try(network.appliance_single_lan, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_single_lan" "appliance_single_lan" {
  for_each                = { for i, v in local.networks_networks_appliance_single_lan : i => v }
  network_id              = each.value.network_id
  subnet                  = try(each.value.data.subnet, local.defaults.meraki.networks.appliance_single_lan.subnet, null)
  appliance_ip            = try(each.value.data.appliance_ip, local.defaults.meraki.networks.appliance_single_lan.appliance_ip, null)
  ipv6_enabled            = try(each.value.data.ipv6.enabled, local.defaults.meraki.networks.appliance_single_lan.ipv6.enabled, null)
  ipv6_prefix_assignments = try(each.value.data.ipv6.prefix_assignments, local.defaults.meraki.networks.appliance_single_lan.ipv6.prefix_assignments, null)
  mandatory_dhcp_enabled  = try(each.value.data.mandatory_dhcp.enabled, local.defaults.meraki.networks.appliance_single_lan.mandatory_dhcp.enabled, null)
}
locals {
  networks_networks_appliance_vlans = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for appliance_vlan in try(network.appliance_vlans, []) : {
            network_id = meraki_network.network["${organization.name}/${network.name}"].id
            data       = try(appliance_vlan, null)
          } if try(network.appliance_vlans, null) != null
        ] if try(network.appliance_vlans, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_vlan" "appliance_vlans" {
  for_each     = { for i, v in local.networks_networks_appliance_vlans : i => v }
  network_id   = each.value.network_id
  vlan_id      = each.value.data.vlan_id
  appliance_ip = try(each.value.data.appliance_ip, local.defaults.meraki.networks.appliance_vlans.appliance_ip, null)
  cidr         = try(each.value.data.cidr, local.defaults.meraki.networks.appliance_vlans.cidr, null)
  # dhcp_boot_filename = try(each.value.data.dhcp_boot_filename, local.defaults.meraki.networks.appliance_vlans.dhcp_boot_filename, null)
  # dhcp_boot_next_server = try(each.value.data.dhcp_boot_next_server, local.defaults.meraki.networks.appliance_vlans.dhcp_boot_next_server, null)
  dhcp_boot_options_enabled = try(each.value.data.dhcp_boot_options_enabled, local.defaults.meraki.networks.appliance_vlans.dhcp_boot_options_enabled, null)
  dhcp_handling             = try(each.value.data.dhcp_handling, local.defaults.meraki.networks.appliance_vlans.dhcp_handling, null)
  dhcp_lease_time           = try(each.value.data.dhcp_lease_time, local.defaults.meraki.networks.appliance_vlans.dhcp_lease_time, null)
  dhcp_options              = try(each.value.data.dhcp_options, local.defaults.meraki.networks.appliance_vlans.dhcp_options, null)
  # dhcp_relay_server_ips = try(each.value.data.dhcp_relay_server_ips, local.defaults.meraki.networks.appliance_vlans.dhcp_relay_server_ips, null)
  # dns_nameservers = try(each.value.data.dns_nameservers, local.defaults.meraki.networks.appliance_vlans.dns_nameservers, null)
  group_policy_id         = try(each.value.data.group_policy_id, local.defaults.meraki.networks.appliance_vlans.group_policy_id, null)
  ipv6_enabled            = try(each.value.data.ipv6.enabled, local.defaults.meraki.networks.appliance_vlans.ipv6.enabled, null)
  ipv6_prefix_assignments = try(each.value.data.ipv6.prefix_assignments, local.defaults.meraki.networks.appliance_vlans.ipv6.prefix_assignments, null)
  mandatory_dhcp_enabled  = try(each.value.data.mandatory_dhcp.enabled, local.defaults.meraki.networks.appliance_vlans.mandatory_dhcp.enabled, null)
  mask                    = try(each.value.data.mask, local.defaults.meraki.networks.appliance_vlans.mask, null)
  name                    = try(each.value.data.name, local.defaults.meraki.networks.appliance_vlans.name, null)
  # reserved_ip_ranges = try(each.value.data.reserved_ip_ranges, local.defaults.meraki.networks.appliance_vlans.reserved_ip_ranges, null)
  subnet             = try(each.value.data.subnet, local.defaults.meraki.networks.appliance_vlans.subnet, null)
  template_vlan_type = try(each.value.data.template_vlan_type, local.defaults.meraki.networks.appliance_vlans.template_vlan_type, null)
  depends_on         = [meraki_appliance_vlans_settings.appliance_vlans_settings]
}
locals {
  networks_networks_appliance_vlans_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance_vlans_settings, null)
        } if try(network.appliance_vlans_settings, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_vlans_settings" "appliance_vlans_settings" {
  for_each      = { for i, v in local.networks_networks_appliance_vlans_settings : i => v }
  network_id    = each.value.network_id
  vlans_enabled = try(each.value.data.vlans_enabled, local.defaults.meraki.networks.appliance_vlans_settings.vlans_enabled, null)
}

locals {
  networks_networks_appliance_vpn_bgp = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance_vpn_bgp, null)
        } if try(network.appliance_vpn_bgp, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_vpn_bgp" "appliance_vpn_bgp" {
  for_each        = { for i, v in local.networks_networks_appliance_vpn_bgp : i => v }
  network_id      = each.value.network_id
  enabled         = try(each.value.data.enabled, local.defaults.meraki.networks.appliance_vpn_bgp.enabled, null)
  as_number       = try(each.value.data.as_number, local.defaults.meraki.networks.appliance_vpn_bgp.as_number, null)
  ibgp_hold_timer = try(each.value.data.ibgp_hold_timer, local.defaults.meraki.networks.appliance_vpn_bgp.ibgp_hold_timer, null)
  neighbors       = try(each.value.data.neighbors, local.defaults.meraki.networks.appliance_vpn_bgp.neighbors, null)
}
locals {
  networks_networks_appliance_vpn_site_to_site_vpn = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance_vpn_site_to_site_vpn, null)
          hubs = [for h in try(network.appliance_vpn_site_to_site_vpn.hubs, []) : {
            use_default_route = try(h.use_default_route, null)
            hub_id            = meraki_network.network["${organization.name}/${h.hub_network_name}"].id
          }]
        } if try(network.appliance_vpn_site_to_site_vpn, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_site_to_site_vpn" "appliance_vpn_site_to_site_vpn" {
  for_each   = { for i, v in local.networks_networks_appliance_vpn_site_to_site_vpn : i => v }
  network_id = each.value.network_id
  mode       = try(each.value.data.mode, local.defaults.meraki.networks.appliance_vpn_site_to_site_vpn.mode, null)
  hubs       = each.value.hubs
  subnets    = try(each.value.data.subnets, local.defaults.meraki.networks.appliance_vpn_site_to_site_vpn.subnets, null)
}
locals {
  networks_networks_appliance_warm_spare = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance_warm_spare, null)
        } if try(network.appliance_warm_spare, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_warm_spare" "appliance_warm_spare" {
  for_each     = { for i, v in local.networks_networks_appliance_warm_spare : i => v }
  network_id   = each.value.network_id
  enabled      = try(each.value.data.enabled, local.defaults.meraki.networks.appliance_warm_spare.enabled, null)
  spare_serial = try(each.value.data.spare_serial, local.defaults.meraki.networks.appliance_warm_spare.spare_serial, null)
  uplink_mode  = try(each.value.data.uplink_mode, local.defaults.meraki.networks.appliance_warm_spare.uplink_mode, null)
  virtual_ip1  = try(each.value.data.virtual_ip1, local.defaults.meraki.networks.appliance_warm_spare.virtual_ip1, null)
  virtual_ip2  = try(each.value.data.virtual_ip2, local.defaults.meraki.networks.appliance_warm_spare.virtual_ip2, null)
}
