locals {
  networks_networks_appliance_content_filtering = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance.content_filtering, null)
        } if try(network.appliance.content_filtering, null) != null
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
  depends_on             = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_networks_appliance_firewall_firewalled_services = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for appliance_firewall_firewalled_service in try(network.appliance.firewall_firewalled_services, []) : {
            network_id = meraki_network.network["${organization.name}/${network.name}"].id
            data       = try(appliance_firewall_firewalled_service, null)
          }
        ] if try(network.appliance.firewall_firewalled_services, null) != null
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
  depends_on  = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_networks_appliance_firewall_inbound_firewall_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance.firewall_inbound_firewall, null)
          rules = [
            for rule in try(network.appliance.firewall_inbound_firewall.rules, []) : {
              comment        = try(rule.comment, null)
              dest_cidr      = try(rule.destination_cidr, null)
              dest_port      = try(rule.destination_port, null)
              policy         = try(rule.policy, null)
              protocol       = try(rule.protocol, null)
              src_cidr       = try(rule.source_cidr, null)
              src_port       = try(rule.source_port, null)
              syslog_enabled = try(rule.syslog, null)
            }
          ]
        } if try(network.appliance.firewall_inbound_firewall, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_inbound_firewall_rules" "appliance_firewall_inbound_firewall_rules" {
  for_each   = { for i, v in local.networks_networks_appliance_firewall_inbound_firewall_rules : i => v }
  network_id = each.value.network_id
  rules      = length(each.value.rules) > 0 ? each.value.rules : null
  depends_on = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_networks_appliance_firewall_l3_firewall_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance.firewall_l3_firewall, null)
          rules = [
            for rule in try(network.appliance.firewall_l3_firewall.rules, []) : {
              comment        = try(rule.comment, null)
              dest_cidr      = try(rule.destination_cidr, null)
              dest_port      = try(rule.destination_port, null)
              policy         = try(rule.policy, null)
              protocol       = try(rule.protocol, null)
              src_cidr       = try(rule.source_cidr, null)
              src_port       = try(rule.source_port, null)
              syslog_enabled = try(rule.syslog, null)
            }
          ]
        } if try(network.appliance.firewall_l3_firewall, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_l3_firewall_rules" "appliance_firewall_l3_firewall_rules" {
  for_each            = { for i, v in local.networks_networks_appliance_firewall_l3_firewall_rules : i => v }
  network_id          = each.value.network_id
  rules               = length(each.value.rules) > 0 ? each.value.rules : null
  syslog_default_rule = try(each.value.data.syslog_default_rule, local.defaults.meraki.networks.appliance_firewall_l3_firewall_rules.syslog_default_rule, null)
  depends_on          = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_networks_appliance_firewall_l7_firewall_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance.firewall_l7_firewall, null)
        } if try(network.appliance.firewall_l7_firewall, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_l7_firewall_rules" "appliance_firewall_l7_firewall_rules" {
  for_each   = { for i, v in local.networks_networks_appliance_firewall_l7_firewall_rules : i => v }
  network_id = each.value.network_id
  rules      = try(each.value.data.rules, local.defaults.meraki.networks.appliance_firewall_l7_firewall_rules.rules, null)
  depends_on = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_networks_appliance_firewall_one_to_many_nat_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance.firewall_one_to_many_nat, null)
        } if try(network.appliance.firewall_one_to_many_nat, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_one_to_many_nat_rules" "appliance_firewall_one_to_many_nat_rules" {
  for_each   = { for i, v in local.networks_networks_appliance_firewall_one_to_many_nat_rules : i => v }
  network_id = each.value.network_id
  rules      = try(each.value.data.rules, local.defaults.meraki.networks.appliance_firewall_one_to_many_nat_rules, null)
  depends_on = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_networks_appliance_firewall_one_to_one_nat_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance.firewall_one_to_one_nat, null)
        } if try(network.appliance.firewall_one_to_one_nat, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_one_to_one_nat_rules" "appliance_firewall_one_to_one_nat_rules" {
  for_each   = { for i, v in local.networks_networks_appliance_firewall_one_to_one_nat_rules : i => v }
  network_id = each.value.network_id
  rules      = try(each.value.data.rules, local.defaults.meraki.networks.appliance_firewall_one_to_one_nat.rules, null)
  depends_on = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_networks_appliance_firewall_port_forwarding_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance.firewall_port_forwarding, null)
        } if try(network.appliance.firewall_port_forwarding, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_port_forwarding_rules" "appliance_firewall_port_forwarding_rules" {
  for_each   = { for i, v in local.networks_networks_appliance_firewall_port_forwarding_rules : i => v }
  network_id = each.value.network_id
  rules      = try(each.value.data.rules, local.defaults.meraki.networks.appliance_firewall_port_forwarding.rules, null)
  depends_on = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_networks_appliance_firewall_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance.firewall_settings, null)
        } if try(network.appliance.firewall_settings, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_firewall_settings" "appliance_firewall_settings" {
  for_each                                 = { for i, v in local.networks_networks_appliance_firewall_settings : i => v }
  network_id                               = each.value.network_id
  spoofing_protection_ip_source_guard_mode = try(each.value.data.spoofing_protection.ip_source_guard.mode, local.defaults.meraki.networks.appliance_firewall_settings.spoofing_protection.ip_source_guard.mode, null)
  depends_on                               = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_networks_appliance_ports = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for appliance_port in try(network.appliance.ports, []) : {
            network_id = meraki_network.network["${organization.name}/${network.name}"].id
            data       = try(appliance_port, null)
          } if try(network.appliance.ports, null) != null
        ] if try(network.appliance.ports, null) != null
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
  depends_on            = [meraki_network_device_claim.net_device_claim, meraki_appliance_vlan.appliance_vlans, meraki_appliance_single_lan.appliance_single_lan]
}
locals {
  networks_networks_appliance_security_intrusion = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance.security_intrusion, null)
        } if try(network.appliance.security_intrusion, null) != null
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
  depends_on                       = [meraki_network_device_claim.net_device_claim]
}
locals {
  networks_networks_appliance_security_malware = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance.security_malware, null)
        } if try(network.appliance.security_malware, null) != null
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
  depends_on    = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_networks_appliance_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance.settings, null)
        } if try(network.appliance.settings, null) != null
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
  depends_on             = [meraki_network_device_claim.net_device_claim]
}
locals {
  networks_networks_appliance_single_lan = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance.single_lan, null)
        } if try(network.appliance.single_lan, null) != null
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
  depends_on              = [meraki_network_device_claim.net_device_claim]
}
locals {
  networks_networks_appliance_vlans = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for appliance_vlan in try(network.appliance.vlans, []) : {
            network_id = meraki_network.network["${organization.name}/${network.name}"].id
            data       = try(appliance_vlan, null)
          } if try(network.appliance.vlans, null) != null
        ] if try(network.appliance.vlans, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_vlan" "appliance_vlans" {
  for_each                = { for i, v in local.networks_networks_appliance_vlans : i => v }
  network_id              = each.value.network_id
  vlan_id                 = each.value.data.vlan_id
  appliance_ip            = try(each.value.data.appliance_ip, local.defaults.meraki.networks.appliance_vlans.appliance_ip, null)
  group_policy_id         = try(each.value.data.group_policy_id, local.defaults.meraki.networks.appliance_vlans.group_policy_id, null)
  ipv6_enabled            = try(each.value.data.ipv6.enabled, local.defaults.meraki.networks.appliance_vlans.ipv6.enabled, null)
  ipv6_prefix_assignments = try(each.value.data.ipv6.prefix_assignments, local.defaults.meraki.networks.appliance_vlans.ipv6.prefix_assignments, null)
  name                    = try(each.value.data.name, local.defaults.meraki.networks.appliance_vlans.name, null)
  subnet                  = try(each.value.data.subnet, local.defaults.meraki.networks.appliance_vlans.subnet, null)
  vpn_nat_subnet          = try(each.value.data.vpn_nat_subnet, local.defaults.meraki.networks.appliance_vlans.vpn_nat_subnet, null)
  depends_on              = [meraki_appliance_vlans_settings.appliance_vlans_settings]
}

resource "meraki_appliance_vlan_dhcp" "appliance_vlans_dhcp" {
  for_each                  = { for i, v in local.networks_networks_appliance_vlans : i => v }
  network_id                = each.value.network_id
  vlan_id                   = each.value.data.vlan_id
  dhcp_boot_options_enabled = try(each.value.data.dhcp_boot_options, local.defaults.meraki.networks.appliance_vlans.dhcp_boot_options, null)
  dhcp_handling             = try(each.value.data.dhcp_handling, local.defaults.meraki.networks.appliance_vlans.dhcp_handling, null)
  dhcp_lease_time           = try(each.value.data.dhcp_lease_time, local.defaults.meraki.networks.appliance_vlans.dhcp_lease_time, null)
  dhcp_options              = try(each.value.data.dhcp_options, local.defaults.meraki.networks.appliance_vlans.dhcp_options, null)
  dns_nameservers           = try(each.value.data.dns_nameservers, local.defaults.meraki.networks.appliance_vlans.dns_nameservers, null)
  mandatory_dhcp_enabled    = try(each.value.data.mandatory_dhcp, local.defaults.meraki.networks.appliance_vlans.mandatory_dhcp, null)
  reserved_ip_ranges        = try(each.value.data.reserved_ip_ranges, local.defaults.meraki.networks.appliance_vlans.reserved_ip_ranges, null)
  depends_on                = [meraki_appliance_vlan.appliance_vlans]
}
locals {
  networks_networks_appliance_vlans_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance.vlans_settings, null)
        } if try(network.appliance.vlans_settings, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_vlans_settings" "appliance_vlans_settings" {
  for_each      = { for i, v in local.networks_networks_appliance_vlans_settings : i => v }
  network_id    = each.value.network_id
  vlans_enabled = try(each.value.data.vlans, local.defaults.meraki.networks.appliance_vlans_settings.vlans, null)
  depends_on    = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_networks_appliance_vpn_bgp = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance.vpn_bgp, null)
        } if try(network.appliance.vpn_bgp, null) != null
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
  depends_on      = [meraki_appliance_site_to_site_vpn.appliance_vpn_site_to_site_vpn]
}
locals {
  networks_networks_appliance_vpn_site_to_site_vpn = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.appliance.vpn_site_to_site_vpn, null)
          hubs = [for h in try(network.appliance.vpn_site_to_site_vpn.hubs, []) : {
            use_default_route = try(h.use_default_route, null)
            hub_id            = meraki_network.network["${organization.name}/${h.hub_network_name}"].id
          }]
        } if try(network.appliance.vpn_site_to_site_vpn, null) != null
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
  depends_on = [meraki_network_device_claim.net_device_claim, meraki_appliance_single_lan.appliance_single_lan, meraki_appliance_vlan.appliance_vlans]
}
locals {
  networks_networks_appliance_warm_spare = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id   = meraki_network.network["${organization.name}/${network.name}"].id
          spare_serial = meraki_device.device["${organization.name}/${network.name}/devices/${network.appliance.warm_spare.spare_device}"].serial
          data         = try(network.appliance.warm_spare, null)
        } if try(network.appliance.warm_spare, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_warm_spare" "appliance_warm_spare" {
  for_each     = { for i, v in local.networks_networks_appliance_warm_spare : i => v }
  network_id   = each.value.network_id
  enabled      = try(each.value.data.enabled, local.defaults.meraki.networks.appliance_warm_spare.enabled, null)
  spare_serial = try(each.value.spare_serial, local.defaults.meraki.networks.appliance_warm_spare.spare_serial, null)
  uplink_mode  = try(each.value.data.uplink_mode, local.defaults.meraki.networks.appliance_warm_spare.uplink_mode, null)
  virtual_ip1  = try(each.value.data.virtual_ip1, local.defaults.meraki.networks.appliance_warm_spare.virtual_ip1, null)
  virtual_ip2  = try(each.value.data.virtual_ip2, local.defaults.meraki.networks.appliance_warm_spare.virtual_ip2, null)
  depends_on   = [meraki_network_device_claim.net_device_claim]
}


locals {
  networks_networks_appliance_static_routes = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for appliance_static_route in try(network.appliance.static_routes, []) : {
            network_id = meraki_network.network["${organization.name}/${network.name}"].id

            data = try(appliance_static_route, null)
          } if try(network.appliance.static_routes, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_static_route" "net_networks_appliance_static_routes" {
  for_each   = { for i, v in local.networks_networks_appliance_static_routes : i => v }
  network_id = each.value.network_id

  name            = try(each.value.data.name, local.defaults.meraki.networks.networks_appliance_static_routes.name, null)
  subnet          = try(each.value.data.subnet, local.defaults.meraki.networks.networks_appliance_static_routes.subnet, null)
  gateway_ip      = try(each.value.data.gateway_ip, local.defaults.meraki.networks.networks_appliance_static_routes.gateway_ip, null)
  gateway_vlan_id = try(each.value.data.gateway_vlan_id, local.defaults.meraki.networks.networks_appliance_static_routes.gateway_vlan_id, null)
}

locals {
  networks_networks_appliance_sdwan_internet_policies = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id

          data = try(network.appliance.sdwan_internet_policies, null)
        } if try(network.appliance.sdwan_internet_policies, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_sdwan_internet_policies" "net_networks_appliance_sdwan_internet_policies" {
  for_each   = { for i, v in local.networks_networks_appliance_sdwan_internet_policies : i => v }
  network_id = each.value.network_id

  wan_traffic_uplink_preferences = try(each.value.data.wan_traffic_uplink_preferences, local.defaults.meraki.networks.networks_appliance_sdwan_internet_policies.wan_traffic_uplink_preferences, null)

}

locals {
  networks_networks_appliance_traffic_shaping = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id

          data = try(network.appliance.traffic_shaping, null)
        } if try(network.appliance.traffic_shaping, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_traffic_shaping" "net_networks_appliance_traffic_shaping" {
  for_each   = { for i, v in local.networks_networks_appliance_traffic_shaping : i => v }
  network_id = each.value.network_id

  global_bandwidth_limit_up   = try(each.value.data.global_bandwidth_limits.limit_up, local.defaults.meraki.networks.networks_appliance_traffic_shaping.global_bandwidth_limits.limit_up, null)
  global_bandwidth_limit_down = try(each.value.data.global_bandwidth_limits.limit_down, local.defaults.meraki.networks.networks_appliance_traffic_shaping.global_bandwidth_limits.limit_down, null)

}

locals {
  networks_networks_appliance_traffic_shaping_custom_performance_classes = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for appliance_traffic_shaping_custom_performance_class in try(network.appliance.traffic_shaping.custom_performance_classes, []) : {
            network_id = meraki_network.network["${organization.name}/${network.name}"].id

            data = try(appliance_traffic_shaping_custom_performance_class, null)
          } if try(network.appliance.traffic_shaping.custom_performance_classes, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_traffic_shaping_custom_performance_class" "net_networks_appliance_traffic_shaping_custom_performance_classes" {
  for_each   = { for i, v in local.networks_networks_appliance_traffic_shaping_custom_performance_classes : i => v }
  network_id = each.value.network_id

  name                = try(each.value.data.name, local.defaults.meraki.networks.networks_appliance_traffic_shaping_custom_performance_classes.name, null)
  max_latency         = try(each.value.data.max_latency, local.defaults.meraki.networks.networks_appliance_traffic_shaping_custom_performance_classes.max_latency, null)
  max_jitter          = try(each.value.data.max_jitter, local.defaults.meraki.networks.networks_appliance_traffic_shaping_custom_performance_classes.max_jitter, null)
  max_loss_percentage = try(each.value.data.max_loss_percentage, local.defaults.meraki.networks.networks_appliance_traffic_shaping_custom_performance_classes.max_loss_percentage, null)

}

locals {
  networks_networks_appliance_traffic_shaping_rules = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id

          data = try(network.appliance.traffic_shaping.rules, null)
        } if try(network.appliance.traffic_shaping.rules, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_traffic_shaping_rules" "net_networks_appliance_traffic_shaping_rules" {
  for_each   = { for i, v in local.networks_networks_appliance_traffic_shaping_rules : i => v }
  network_id = each.value.network_id

  default_rules_enabled = try(each.value.data.default_rules, local.defaults.meraki.networks.networks_appliance_traffic_shaping_rules.default_rules_enabled, null)
  rules                 = try(each.value.data.rules, local.defaults.meraki.networks.networks_appliance_traffic_shaping_rules.rules, null)

}

locals {
  networks_networks_appliance_traffic_shaping_uplink_bandwidth = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id

          data = try(network.appliance.traffic_shaping.uplink_bandwidth, null)
        } if try(network.appliance.traffic_shaping.uplink_bandwidth, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_traffic_shaping_uplink_bandwidth" "net_networks_appliance_traffic_shaping_uplink_bandwidth" {
  for_each   = { for i, v in local.networks_networks_appliance_traffic_shaping_uplink_bandwidth : i => v }
  network_id = each.value.network_id

  wan1_limit_up       = try(each.value.data.wan1_limit_up, local.defaults.meraki.networks.networks_appliance_traffic_shaping_uplink_bandwidth.bandwidth_limits.wan1.limit_up, null)
  wan1_limit_down     = try(each.value.data.wan1_limit_down, local.defaults.meraki.networks.networks_appliance_traffic_shaping_uplink_bandwidth.bandwidth_limits.wan1.limit_down, null)
  wan2_limit_up       = try(each.value.data.wan2_limit_up, local.defaults.meraki.networks.networks_appliance_traffic_shaping_uplink_bandwidth.bandwidth_limits.wan2.limit_up, null)
  wan2_limit_down     = try(each.value.data.wan2_limit_down, local.defaults.meraki.networks.networks_appliance_traffic_shaping_uplink_bandwidth.bandwidth_limits.wan2.limit_down, null)
  cellular_limit_up   = try(each.value.data.cellular_limit_up, local.defaults.meraki.networks.networks_appliance_traffic_shaping_uplink_bandwidth.bandwidth_limits.cellular.limit_up, null)
  cellular_limit_down = try(each.value.data.cellular_limit_down, local.defaults.meraki.networks.networks_appliance_traffic_shaping_uplink_bandwidth.bandwidth_limits.cellular.limit_down, null)

}

locals {
  networks_networks_appliance_traffic_shaping_uplink_selection = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id

          data = try(network.appliance.traffic_shaping.uplink_selection, null)
        } if try(network.appliance.traffic_shaping.uplink_selection, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_traffic_shaping_uplink_selection" "net_networks_appliance_traffic_shaping_uplink_selection" {
  for_each   = { for i, v in local.networks_networks_appliance_traffic_shaping_uplink_selection : i => v }
  network_id = each.value.network_id

  active_active_auto_vpn_enabled          = try(each.value.data.active_active_auto_vpn, local.defaults.meraki.networks.networks_appliance_traffic_shaping_uplink_selection.active_active_auto_vpn_enabled, null)
  default_uplink                          = try(each.value.data.default_uplink, local.defaults.meraki.networks.networks_appliance_traffic_shaping_uplink_selection.default_uplink, null)
  load_balancing_enabled                  = try(each.value.data.load_balancing, local.defaults.meraki.networks.networks_appliance_traffic_shaping_uplink_selection.load_balancing_enabled, null)
  failover_and_failback_immediate_enabled = try(each.value.data.failover_and_failback_immediate, local.defaults.meraki.networks.networks_appliance_traffic_shaping_uplink_selection.failover_and_failback_immediate, null)
  wan_traffic_uplink_preferences          = try(each.value.data.wan_traffic_uplink_preferences, local.defaults.meraki.networks.networks_appliance_traffic_shaping_uplink_selection.wan_traffic_uplink_preferences, null)
  vpn_traffic_uplink_preferences          = try(each.value.data.vpn_traffic_uplink_preferences, local.defaults.meraki.networks.networks_appliance_traffic_shaping_uplink_selection.vpn_traffic_uplink_preferences, null)

}

locals {
  networks_networks_appliance_traffic_shaping_vpn_exclusions = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id

          data = try(network.appliance.traffic_shaping.vpn_exclusions, null)
        } if try(network.appliance.traffic_shaping.vpn_exclusions, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_traffic_shaping_vpn_exclusions" "net_networks_appliance_traffic_shaping_vpn_exclusions" {
  for_each   = { for i, v in local.networks_networks_appliance_traffic_shaping_vpn_exclusions : i => v }
  network_id = each.value.network_id

  custom             = try(each.value.data.custom, local.defaults.meraki.networks.networks_appliance_traffic_shaping_vpn_exclusions.custom, null)
  major_applications = try(each.value.data.major_applications, local.defaults.meraki.networks.networks_appliance_traffic_shaping_vpn_exclusions.major_applications, null)

}

locals {
  networks_networks_appliance_ssids = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for appliance_ssid in try(network.appliance.ssids, []) : {
            network_id = meraki_network.network["${organization.name}/${network.name}"].id
            key        = "${organization.name}/${network.name}/ssids/${appliance_ssid.name}"

            data = try(appliance_ssid, null)
          } if try(network.appliance.ssids, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_ssid" "net_networks_appliance_ssids" {
  for_each   = { for v in local.networks_networks_appliance_ssids : v.key => v }
  network_id = each.value.network_id
  number     = each.value.data.number

  name                                   = try(each.value.data.name, local.defaults.meraki.networks.networks_appliance_ssids.name, null)
  enabled                                = try(each.value.data.enabled, local.defaults.meraki.networks.networks_appliance_ssids.enabled, null)
  default_vlan_id                        = try(each.value.data.default_vlan_id, local.defaults.meraki.networks.networks_appliance_ssids.default_vlan_id, null)
  auth_mode                              = try(each.value.data.auth_mode, local.defaults.meraki.networks.networks_appliance_ssids.auth_mode, null)
  psk                                    = try(each.value.data.psk, local.defaults.meraki.networks.networks_appliance_ssids.psk, null)
  radius_servers                         = try(each.value.data.radius_servers, local.defaults.meraki.networks.networks_appliance_ssids.radius_servers, null)
  encryption_mode                        = try(each.value.data.encryption_mode, local.defaults.meraki.networks.networks_appliance_ssids.encryption_mode, null)
  wpa_encryption_mode                    = try(each.value.data.wpa_encryption_mode, local.defaults.meraki.networks.networks_appliance_ssids.wpa_encryption_mode, null)
  visible                                = try(each.value.data.visible, local.defaults.meraki.networks.networks_appliance_ssids.visible, null)
  dhcp_enforced_deauthentication_enabled = try(each.value.data.dhcp_enforced_deauthentication, local.defaults.meraki.networks.networks_appliance_ssids.dhcp_enforced_deauthentication, null)
  dot11w_enabled                         = try(each.value.data.dot11w_enabled, local.defaults.meraki.networks.networks_appliance_ssids.dot11w.enabled, null)
  dot11w_required                        = try(each.value.data.dot11w_required, local.defaults.meraki.networks.networks_appliance_ssids.dot11w.required, null)

}

locals {
  appliance_per_ssid_settings_list = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for appliance_rf_profile in try(network.appliance.rf_profiles, []) : [
            for settings in appliance_rf_profile.per_ssid_settings : {
              key  = format("${organization.name}/${network.name}/${appliance_rf_profile.name}/%s", meraki_appliance_ssid.net_networks_appliance_ssids["${organization.name}/${network.name}/ssids/${settings.ssid_name}"].number)
              data = settings
            }
          ]
        ]
      ]
    ]
  ])
  appliance_per_ssid_settings = { for s in local.appliance_per_ssid_settings_list : s.key => s.data }
  networks_networks_appliance_rf_profiles = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for appliance_rf_profile in try(network.appliance.rf_profiles, []) : {
            network_id        = meraki_network.network["${organization.name}/${network.name}"].id
            per_ssid_settings = [for i in range(15) : try(local.appliance_per_ssid_settings["${organization.name}/${network.name}/${appliance_rf_profile.name}/${i}"], null)]
            key               = "${organization.name}/${network.name}/${appliance_rf_profile.name}"
            data              = try(appliance_rf_profile, null)
          } if try(network.appliance.rf_profiles, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_rf_profile" "net_networks_appliance_rf_profiles" {
  for_each   = { for v in local.networks_networks_appliance_rf_profiles : v.key => v }
  network_id = each.value.network_id

  name                                      = try(each.value.data.name, local.defaults.meraki.networks.networks_appliance_rf_profiles.name, null)
  two_four_ghz_settings_min_bitrate         = try(each.value.data.two_four_ghz_settings.min_bitrate, local.defaults.meraki.networks.networks_appliance_rf_profiles.two_four_ghz_settings.min_bitrate, null)
  two_four_ghz_settings_ax_enabled          = try(each.value.data.two_four_ghz_settings.ax_enabled, local.defaults.meraki.networks.networks_appliance_rf_profiles.two_four_ghz_settings.ax_enabled, null)
  five_ghz_settings_min_bitrate             = try(each.value.data.five_ghz_settings.min_bitrate, local.defaults.meraki.networks.networks_appliance_rf_profiles.five_ghz_settings.min_bitrate, null)
  five_ghz_settings_ax_enabled              = try(each.value.data.five_ghz_settings.ax_enabled, local.defaults.meraki.networks.networks_appliance_rf_profiles.five_ghz_settings.ax_enabled, null)
  per_ssid_settings_1_band_operation_mode   = try(each.value.data.per_ssid_settings[0].band_operation_mode, local.defaults.meraki.networks.networks_appliance_rf_profiles.per_ssid_settings[0].band_operation_mode, null)
  per_ssid_settings_1_band_steering_enabled = try(each.value.data.per_ssid_settings[0].band_steering_enabled, local.defaults.meraki.networks.networks_appliance_rf_profiles.per_ssid_settings[0].band_steering_enabled, null)
  per_ssid_settings_2_band_operation_mode   = try(each.value.data.per_ssid_settings[1].band_operation_mode, local.defaults.meraki.networks.networks_appliance_rf_profiles.per_ssid_settings[1].band_operation_mode, null)
  per_ssid_settings_2_band_steering_enabled = try(each.value.data.per_ssid_settings[1].band_steering_enabled, local.defaults.meraki.networks.networks_appliance_rf_profiles.per_ssid_settings[1].band_steering_enabled, null)
  per_ssid_settings_3_band_operation_mode   = try(each.value.data.per_ssid_settings[2].band_operation_mode, local.defaults.meraki.networks.networks_appliance_rf_profiles.per_ssid_settings[2].band_operation_mode, null)
  per_ssid_settings_3_band_steering_enabled = try(each.value.data.per_ssid_settings[2].band_steering_enabled, local.defaults.meraki.networks.networks_appliance_rf_profiles.per_ssid_settings[2].band_steering_enabled, null)
  per_ssid_settings_4_band_operation_mode   = try(each.value.data.per_ssid_settings[3].band_operation_mode, local.defaults.meraki.networks.networks_appliance_rf_profiles.per_ssid_settings[3].band_operation_mode, null)
  per_ssid_settings_4_band_steering_enabled = try(each.value.data.per_ssid_settings[3].band_steering_enabled, local.defaults.meraki.networks.networks_appliance_rf_profiles.per_ssid_settings[3].band_steering_enabled, null)

}

locals {
  networks_devices_appliance_radio_settings = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for device in try(network.devices, []) : {
            serial        = meraki_device.device["${organization.name}/${network.name}/devices/${device.name}"].serial
            rf_profile_id = meraki_appliance_rf_profile.net_networks_appliance_rf_profiles["${organization.name}/${network.name}/${device.appliance.radio_settings.rf_profile_name}"].id

            data = try(device.appliance.radio_settings, null)
          } if try(device.appliance.radio_settings, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
  # marcin_debug = local.networks_devices_appliance_radio_settings
}

resource "meraki_appliance_radio_settings" "net_devices_appliance_radio_settings" {
  for_each = { for i, v in local.networks_devices_appliance_radio_settings : i => v }
  serial   = each.value.serial

  rf_profile_id                      = each.value.rf_profile_id
  two_four_ghz_settings_channel      = try(each.value.data.two_four_ghz_settings.channel, local.defaults.meraki.networks.devices_appliance_radio_settings.two_four_ghz_settings.channel, null)
  two_four_ghz_settings_target_power = try(each.value.data.two_four_ghz_settings.target_power, local.defaults.meraki.networks.devices_appliance_radio_settings.two_four_ghz_settings.target_power, null)
  five_ghz_settings_channel          = try(each.value.data.five_ghz_settings.channel, local.defaults.meraki.networks.devices_appliance_radio_settings.five_ghz_settings.channel, null)
  five_ghz_settings_channel_width    = try(each.value.data.five_ghz_settings.channel_width, local.defaults.meraki.networks.devices_appliance_radio_settings.five_ghz_settings.channel_width, null)
  five_ghz_settings_target_power     = try(each.value.data.five_ghz_settings.target_power, local.defaults.meraki.networks.devices_appliance_radio_settings.five_ghz_settings.target_power, null)

}
