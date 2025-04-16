locals {
  networks_networks_appliance_content_filtering = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                    = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id             = meraki_network.network[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          allowed_url_patterns   = try(each.value.appliance.content_filtering.allowed_url_patterns, local.defaults.meraki.networks.appliance.content_filtering.allowed_url_patterns, null)
          blocked_url_patterns   = try(each.value.appliance.content_filtering.blocked_url_patterns, local.defaults.meraki.networks.appliance.content_filtering.blocked_url_patterns, null)
          blocked_url_categories = try(each.value.appliance.content_filtering.blocked_url_categories, local.defaults.meraki.networks.appliance.content_filtering.blocked_url_categories, null)
          url_category_list_size = try(each.value.appliance.content_filtering.url_category_list_size, local.defaults.meraki.networks.appliance.content_filtering.url_category_list_size, null)
        } if try(network.appliance.content_filtering, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_content_filtering" "appliance_content_filtering" {
  for_each               = { for v in local.networks_networks_appliance_content_filtering : v.key => v }
  network_id             = each.value.network_id
  allowed_url_patterns   = each.value.allowed_url_patterns
  blocked_url_patterns   = each.value.blocked_url_patterns
  blocked_url_categories = each.value.blocked_url_categories
  url_category_list_size = each.value.url_category_list_size
  depends_on             = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_networks_appliance_firewall_firewalled_services = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for appliance_firewall_firewalled_service in try(network.appliance.firewall.firewalled_services, []) : {
            key         = format("%s/%s/%s/%s", domain.name, organization.name, network.name, appliance_firewall_firewalled_service.service_name)
            network_id  = meraki_network.network[format("%s/%s/%s", domain.name, organization.name, network.name)].id
            access      = try(each.value.access, local.defaults.meraki.networks.appliance_firewall_firewalled_services.access, null)
            allowed_ips = try(each.value.allowed_ips, local.defaults.meraki.networks.appliance_firewall_firewalled_services.allowed_ips, null)
            service     = try(each.value.service_name, local.defaults.meraki.networks.appliance_firewall_firewalled_services.service_name, null)
          }
        ]
      ]
    ]
  ])
}

resource "meraki_appliance_firewalled_service" "appliance_firewall_firewalled_services" {
  for_each    = { for v in local.networks_networks_appliance_firewall_firewalled_services : v.key => v }
  network_id  = each.value.network_id
  access      = each.value.access
  allowed_ips = each.value.allowed_ips
  service     = each.value.service
  depends_on  = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_networks_appliance_firewall_inbound_firewall_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = meraki_network.network[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          rules = try(length(network.appliance.firewall.inbound_firewall_rules.rules) == 0, true) ? null : [
            for rule in try(network.appliance.firewall.inbound_firewall_rules.rules, []) : {
              comment        = try(rule.comment, local.defaults.meraki.networks.appliance.firewall.inbound_firewall_rules.rules.comment, null)
              dest_cidr      = try(rule.destination_cidr, local.defaults.meraki.networks.appliance.firewall.inbound_firewall_rules.rules.destination_cidr, null)
              dest_port      = try(rule.destination_port, local.defaults.meraki.networks.appliance.firewall.inbound_firewall_rules.rules.destination_port, null)
              policy         = try(rule.policy, local.defaults.meraki.networks.appliance.firewall.inbound_firewall_rules.rules.policy, null)
              protocol       = try(rule.protocol, local.defaults.meraki.networks.appliance.firewall.inbound_firewall_rules.rules.protocol, null)
              src_cidr       = try(rule.source_cidr, local.defaults.meraki.networks.appliance.firewall.inbound_firewall_rules.rules.source_cidr, null)
              src_port       = try(rule.source_port, local.defaults.meraki.networks.appliance.firewall.inbound_firewall_rules.rules.source_port, null)
              syslog_enabled = try(rule.syslog, local.defaults.meraki.networks.appliance.firewall.inbound_firewall_rules.rules.syslog, null)
            }
          ]
        } if length(try(network.appliance.firewall.inbound_firewall_rules.rules, [])) > 0
      ]
    ]
  ])
}

resource "meraki_appliance_inbound_firewall_rules" "appliance_firewall_inbound_firewall_rules" {
  for_each   = { for v in local.networks_networks_appliance_firewall_inbound_firewall_rules : v.key => v }
  network_id = each.value.network_id
  rules      = each.value.rules
  depends_on = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_networks_appliance_firewall_l3_firewall_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                 = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id          = meraki_network.network[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          syslog_default_rule = try(data.syslog_default_rule, local.defaults.meraki.networks.appliance.firewall.l3_firewall_rules.syslog_default_rule, null)
          rules = try(length(network.appliance.firewall.l3_firewall_rules.rules) == 0, true) ? null : [
            for rule in try(network.appliance.firewall.l3_firewall_rules.rules, []) : {
              comment        = try(rule.comment, local.defaults.meraki.networks.appliance.firewall.l3_firewall_rules.rules.comment, null)
              dest_cidr      = try(rule.destination_cidr, local.defaults.meraki.networks.appliance.firewall.l3_firewall_rules.rules.destination_cidr, null)
              dest_port      = try(rule.destination_port, local.defaults.meraki.networks.appliance.firewall.l3_firewall_rules.rules.destination_port, null)
              policy         = try(rule.policy, local.defaults.meraki.networks.appliance.firewall.l3_firewall_rules.rules.policy, null)
              protocol       = try(rule.protocol, local.defaults.meraki.networks.appliance.firewall.l3_firewall_rules.rules.protocol, null)
              src_cidr       = try(rule.source_cidr, local.defaults.meraki.networks.appliance.firewall.l3_firewall_rules.rules.source_cidr, null)
              src_port       = try(rule.source_port, local.defaults.meraki.networks.appliance.firewall.l3_firewall_rules.rules.source_port, null)
              syslog_enabled = try(rule.syslog, local.defaults.meraki.networks.appliance.firewall.l3_firewall_rules.rules.syslog, null)
            }
          ]
        }
      ]
    ]
  ])
}

resource "meraki_appliance_l3_firewall_rules" "appliance_firewall_l3_firewall_rules" {
  for_each            = { for v in local.networks_networks_appliance_firewall_l3_firewall_rules : v.key => v }
  network_id          = each.value.network_id
  syslog_default_rule = each.value.data.syslog_default_rule
  rules               = each.value.rules
  depends_on          = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_networks_appliance_firewall_l7_firewall_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = meraki_network.network[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          data       = try(network.appliance.firewall.l7_firewall_rules, null)
          rules = try(length(network.appliance.firewall.l7_firewall_rules) == 0, true) ? null : [
            for rule in try(network.appliance.firewall.l7_firewall_rules, []) : {
              policy = try(rule.policy, local.defaults.meraki.networks.appliance.firewall.l7_firewall_rules.policy, null)
              type   = try(rule.type, local.defaults.meraki.networks.appliance.firewall.l7_firewall_rules.type, null)
              value  = try(rule.value, local.defaults.meraki.networks.appliance.firewall.l7_firewall_rules.value, null)
            }
          ]
        } if length(try(network.appliance.firewall.l7_firewall_rules, [])) > 0
      ]
    ]
  ])
}

resource "meraki_appliance_l7_firewall_rules" "appliance_firewall_l7_firewall_rules" {
  for_each   = { for v in local.networks_networks_appliance_firewall_l7_firewall_rules : v.key => v }
  network_id = each.value.network_id
  rules      = each.value.data
  depends_on = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_networks_appliance_firewall_one_to_many_nat_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = meraki_network.network[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          data       = try(network.appliance.firewall.one_to_many_nat_rules, null)
          rules = try(length(network.appliance.firewall.one_to_many_nat_rules) == 0, true) ? null : [
            for rule in try(network.appliance.firewall.one_to_many_nat_rules, []) : {
              public_ip = try(rule.public_ip, local.defaults.meraki.networks.appliance.firewall.one_to_many_nat_rules.public_ip, null)
              uplink    = try(rule.uplink, local.defaults.meraki.networks.appliance.firewall.one_to_many_nat_rules.uplink, null)
              port_rules = try(length(rule.port_rules) == 0, true) ? null : [
                for pr in try(rule.port_rules, []) : {
                  allowed_ips = try(pr.allowed_ips, local.defaults.meraki.networks.appliance.firewall.one_to_many_nat_rules.port_rules.allowed_ips, null)
                  local_ip    = try(pr.local_ip, local.defaults.meraki.networks.appliance.firewall.one_to_many_nat_rules.port_rules.local_ip, null)
                  local_port  = try(pr.local_port, local.defaults.meraki.networks.appliance.firewall.one_to_many_nat_rules.port_rules.local_port, null)
                  protocol    = try(pr.protocol, local.defaults.meraki.networks.appliance.firewall.one_to_many_nat_rules.port_rules.protocol, null)
                  public_port = try(pr.public_port, local.defaults.meraki.networks.appliance.firewall.one_to_many_nat_rules.port_rules.public_port, null)
                }
              ]
            }
          ]
        } if length(try(network.appliance.firewall.one_to_many_nat_rules, [])) > 0
      ]
    ]
  ])
}

resource "meraki_appliance_one_to_many_nat_rules" "appliance_firewall_one_to_many_nat_rules" {
  for_each   = { for v in local.networks_networks_appliance_firewall_one_to_many_nat_rules : v.key => v }
  network_id = each.value.network_id
  rules      = each.value.rules
  depends_on = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_networks_appliance_firewall_one_to_one_nat_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = meraki_network.network[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          data       = try(network.appliance.firewall.one_to_one_nat_rules, null)
          rules = try(length(network.appliance.firewall.one_to_one_nat_rules) == 0, true) ? null : [
            for rule in try(network.appliance.firewall.one_to_one_nat_rules, []) : {
              lan_ip    = try(rule.lan_ip, local.defaults.meraki.networks.appliance.firewall.one_to_one_nat_rules.lan_ip, null)
              public_ip = try(rule.public_ip, local.defaults.meraki.networks.appliance.firewall.one_to_one_nat_rules.public_ip, null)
              uplink    = try(rule.uplink, local.defaults.meraki.networks.appliance.firewall.one_to_one_nat_rules.uplink, null)
              name      = try(rule.name, local.defaults.meraki.networks.appliance.firewall.one_to_one_nat_rules.name, null)
              allowed_inbound = try(length(rule.allowed_inbound) == 0, true) ? null : [
                for ai in try(rule.allowed_inbound, []) : {
                  allowed_ips       = try(ai.allowed_ips, local.defaults.meraki.networks.appliance.firewall.one_to_one_nat_rules.allowed_inbound.allowed_ips, null)
                  destination_ports = try(ai.destination_ports, local.defaults.meraki.networks.appliance.firewall.one_to_one_nat_rules.allowed_inbound.destination_ports, null)
                  protocol          = try(ai.protocol, local.defaults.meraki.networks.appliance.firewall.one_to_one_nat_rules.allowed_inbound.protocol, null)
                }
              ]
            }
          ]
        } if length(try(network.appliance.firewall.one_to_one_nat_rules, [])) > 0
      ]
    ]
  ])
}

resource "meraki_appliance_one_to_one_nat_rules" "appliance_firewall_one_to_one_nat_rules" {
  for_each   = { for v in local.networks_networks_appliance_firewall_one_to_one_nat_rules : v.key => v }
  network_id = each.value.network_id
  rules      = each.value.rules
  depends_on = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_networks_appliance_firewall_port_forwarding_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = meraki_network.network[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          data       = try(network.appliance.firewall.port_forwarding_rules, null)
          rules = try(length(network.appliance.firewall.port_forwarding_rules) == 0, true) ? null : [
            for rule in try(network.appliance.firewall.port_forwarding_rules, []) : {
              allowed_ips = try(rule.allowed_ips, local.defaults.meraki.networks.appliance.firewall.port_forwarding_rules.allowed_ips, null)
              lan_ip      = try(rule.lan_ip, local.defaults.meraki.networks.appliance.firewall.port_forwarding_rules.lan_ip, null)
              local_port  = try(rule.local_port, local.defaults.meraki.networks.appliance.firewall.port_forwarding_rules.local_port, null)
              protocol    = try(rule.protocol, local.defaults.meraki.networks.appliance.firewall.port_forwarding_rules.protocol, null)
              public_port = try(rule.public_port, local.defaults.meraki.networks.appliance.firewall.port_forwarding_rules.public_port, null)
              name        = try(rule.name, local.defaults.meraki.networks.appliance.firewall.port_forwarding_rules.name, null)
              uplink      = try(rule.uplink, local.defaults.meraki.networks.appliance.firewall.port_forwarding_rules.uplink, null)
            }
          ]
        } if length(try(network.appliance.firewall.port_forwarding_rules, [])) > 0
      ]
    ]
  ])
}

resource "meraki_appliance_port_forwarding_rules" "appliance_firewall_port_forwarding_rules" {
  for_each   = { for v in local.networks_networks_appliance_firewall_port_forwarding_rules : v.key => v }
  network_id = each.value.network_id
  rules      = each.value.rules
  depends_on = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_networks_appliance_firewall_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                                      = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id                               = meraki_network.network[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          spoofing_protection_ip_source_guard_mode = try(network.appliance.firewall_settings.spoofing_protection.ip_source_guard.mode, local.defaults.meraki.networks.appliance.firewall_settings.spoofing_protection.ip_source_guard.mode, null)
        } if try(network.appliance.firewall_settings, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_firewall_settings" "appliance_firewall_settings" {
  for_each                                 = { for v in local.networks_networks_appliance_firewall_settings : v.key => v }
  network_id                               = each.value.network_id
  spoofing_protection_ip_source_guard_mode = each.value.spoofing_protection_ip_source_guard_mode
  depends_on                               = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_networks_appliance_ports = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for appliance_port in try(network.appliance.ports, []) : {
            key                   = format("%s/%s/%s/%s", domain.name, organization.name, network.name, appliance_port.port_id)
            network_id            = meraki_network.network[format("%s/%s/%s", domain.name, organization.name, network.name)].id
            enabled               = try(appliance_port.enabled, local.defaults.meraki.networks.appliance_ports.enabled, null)
            drop_untagged_traffic = try(appliance_port.drop_untagged_traffic, local.defaults.meraki.networks.appliance_ports.drop_untagged_traffic, null)
            type                  = try(appliance_port.type, local.defaults.meraki.networks.appliance_ports.type, null)
            vlan                  = try(appliance_port.vlan, local.defaults.meraki.networks.appliance_ports.vlan, null)
            allowed_vlans         = try(appliance_port.allowed_vlans, local.defaults.meraki.networks.appliance_ports.allowed_vlans, null)
            access_policy         = try(appliance_port.access_policy, local.defaults.meraki.networks.appliance_ports.access_policy, null)
            port_id               = try(appliance_port.port_id, local.defaults.meraki.networks.appliance_ports.port_id, null)
          }
        ]
      ]
    ]
  ])
}

resource "meraki_appliance_port" "appliance_ports" {
  for_each              = { for v in local.networks_networks_appliance_ports : v.key => v }
  network_id            = each.value.network_id
  enabled               = each.value.enabled
  drop_untagged_traffic = each.value.drop_untagged_traffic
  type                  = each.value.type
  vlan                  = each.value.vlan
  allowed_vlans         = each.value.allowed_vlans
  access_policy         = each.value.access_policy
  port_id               = each.value.data.port_id
  depends_on            = [meraki_network_device_claim.net_device_claim, meraki_appliance_vlan.appliance_vlans, meraki_appliance_single_lan.appliance_single_lan]
}

locals {
  networks_networks_appliance_security_intrusion = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                              = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id                       = meraki_network.network[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          mode                             = try(network.appliance.security_intrusion.mode, local.defaults.meraki.networks.appliance.security_intrusion.mode, null)
          ids_rulesets                     = try(network.appliance.security_intrusion.ids_rulesets, local.defaults.meraki.networks.appliance.security_intrusion.ids_rulesets, null)
          protected_networks_use_default   = try(network.appliance.security_intrusion.protected_networks.use_default, local.defaults.meraki.networks.appliance_security_intrusion.protected_networks.use_default, null)
          protected_networks_included_cidr = try(network.appliance.security_intrusion.protected_networks.included_cidr, local.defaults.meraki.networks.appliance_security_intrusion.protected_networks.included_cidr, null)
          protected_networks_excluded_cidr = try(network.appliance.security_intrusion.protected_networks.excluded_cidr, local.defaults.meraki.networks.appliance_security_intrusion.protected_networks.excluded_cidr, null)
        } if try(network.appliance.security_intrusion, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_network_security_intrusion" "appliance_security_intrusion" {
  for_each                         = { for v in local.networks_networks_appliance_security_intrusion : v.key => v }
  network_id                       = each.value.network_id
  mode                             = each.value.mode
  ids_rulesets                     = each.value.ids_rulesets
  protected_networks_use_default   = each.value.protected_networks_use_default
  protected_networks_included_cidr = each.value.protected_networks_included_cidr
  protected_networks_excluded_cidr = each.value.protected_networks_excluded_cidr
  depends_on                       = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_networks_appliance_security_malware = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key           = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id    = meraki_network.network[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          mode          = try(network.appliance.security_malware.mode, local.defaults.meraki.networks.appliance.security_malware.mode, null)
          allowed_urls  = try(network.appliance.security_malware.allowed_urls, local.defaults.meraki.networks.appliance.security_malware.allowed_urls, null)
          allowed_files = try(network.appliance.security_malware.allowed_files, local.defaults.meraki.networks.appliance.security_malware.allowed_files, null)
        } if try(network.appliance.security_malware, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_security_malware" "appliance_security_malware" {
  for_each      = { for v in local.networks_networks_appliance_security_malware : v.key => v }
  network_id    = each.value.network_id
  mode          = each.value.mode
  allowed_urls  = each.value.allowed_urls
  allowed_files = each.value.allowed_files
  depends_on    = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_networks_appliance_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                    = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id             = meraki_network.network[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          client_tracking_method = try(network.appliance.settings.client_tracking_method, local.defaults.meraki.networks.appliance.settings.client_tracking_method, null)
          deployment_mode        = try(network.appliance.settings.deployment_mode, local.defaults.meraki.networks.appliance.settings.deployment_mode, null)
          dynamic_dns_prefix     = try(network.appliance.settings.dynamic_dns.prefix, local.defaults.meraki.networks.appliance.settings.dynamic_dns.prefix, null)
          dynamic_dns_enabled    = try(network.appliance.settings.dynamic_dns.enabled, local.defaults.meraki.networks.appliance.settings.dynamic_dns.enabled, null)
        } if try(network.appliance.settings, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_settings" "appliance_settings" {
  for_each               = { for v in local.networks_networks_appliance_settings : v.key => v }
  network_id             = each.value.network_id
  client_tracking_method = each.value.client_tracking_method
  deployment_mode        = each.value.deployment_mode
  dynamic_dns_prefix     = each.value.dynamic_dns_prefix
  dynamic_dns_enabled    = each.value.dynamic_dns_enabled
  depends_on             = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_networks_appliance_single_lan = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                     = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id              = meraki_network.network[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          subnet                  = try(network.appliance.single_lan.subnet, local.defaults.meraki.networks.appliance.single_lan.subnet, null)
          appliance_ip            = try(network.appliance.single_lan.appliance_ip, local.defaults.meraki.networks.appliance.single_lan.appliance_ip, null)
          ipv6_enabled            = try(network.appliance.single_lan.ipv6.enabled, local.defaults.meraki.networks.appliance.single_lan.ipv6.enabled, null)
          ipv6_prefix_assignments = try(network.appliance.single_lan.ipv6.prefix_assignments, local.defaults.meraki.networks.appliance.single_lan.ipv6.prefix_assignments, null)
          mandatory_dhcp_enabled  = try(network.appliance.single_lan.mandatory_dhcp.enabled, local.defaults.meraki.networks.appliance.single_lan.mandatory_dhcp.enabled, null)
        } if try(network.appliance.single_lan, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_single_lan" "appliance_single_lan" {
  for_each                = { for v in local.networks_networks_appliance_single_lan : v.key => v }
  network_id              = each.value.network_id
  subnet                  = each.value.subnet
  appliance_ip            = each.value.appliance_ip
  ipv6_enabled            = each.value.ipv6_enabled
  ipv6_prefix_assignments = each.value.ipv6_prefix_assignments
  mandatory_dhcp_enabled  = each.value.mandatory_dhcp_enabled
  depends_on              = [meraki_network_device_claim.net_device_claim]
}
locals {
  networks_networks_appliance_vlans = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for appliance_vlan in try(network.appliance.vlans, []) : {
            key                       = format("%s/%s/%s/%s", domain.name, organization.name, network.name, appliance_vlan.vlan_id)
            network_id                = meraki_network.network[format("%s/%s/%s", domain.name, organization.name, network.name)].id
            vlan_id                   = try(appliance_vlan.vlan_id, local.defaults.meraki.networks.appliance.vlans.vlan_id, null)
            appliance_ip              = try(appliance_vlan.appliance_ip, local.defaults.meraki.networks.appliance.vlans.appliance_ip, null)
            group_policy_id           = try(appliance_vlan.group_policy_id, local.defaults.meraki.networks.appliance.vlans.group_policy_id, null)
            ipv6                      = try(appliance_vlan.ipv6.enabled, local.defaults.meraki.networks.appliance.vlans.ipv6.enabled, null)
            ipv6_prefix_assignments   = try(appliance_vlan.ipv6.prefix_assignments, local.defaults.meraki.networks.appliance.vlans.ipv6.prefix_assignments, null)
            name                      = try(appliance_vlan.name, local.defaults.meraki.networks.appliance.vlans.name, null)
            subnet                    = try(appliance_vlan.subnet, local.defaults.meraki.networks.appliance.vlans.subnet, null)
            vpn_nat_subnet            = try(appliance_vlan.vpn_nat_subnet, local.defaults.meraki.networks.appliance.vlans.vpn_nat_subnet, null)
            dhcp_boot_options_enabled = try(appliance_vlan.dhcp_boot_options_enabled, local.defaults.meraki.networks.appliance.vlans.dhcp_boot_options, null)
            dhcp_lease_time           = try(appliance_vlan.dhcp_lease_time, local.defaults.meraki.networks.appliance.vlans.dhcp_lease_time, null)
            dhcp_options              = try(appliance_vlan.dhcp_options, local.defaults.meraki.networks.appliance.vlans.dhcp_options, null)
            dns_nameservers           = try(appliance_vlan.dns_nameservers, local.defaults.meraki.networks.appliance.vlans.dns_nameservers, null)
            mandatory_dhcp_enabled    = try(appliance_vlan.mandatory_dhcp_enabled, local.defaults.meraki.networks.appliance.vlans.mandatory_dhcp, null)
            reserved_ip_ranges        = try(appliance_vlan.reserved_ip_ranges, local.defaults.meraki.networks.appliance.vlans.reserved_ip_ranges, null)
          }
        ]
      ]
    ]
  ])
}

resource "meraki_appliance_vlan" "appliance_vlans" {
  for_each                = { for v in local.networks_networks_appliance_vlans : v.key => v }
  network_id              = each.value.network_id
  vlan_id                 = each.value.vlan_id
  appliance_ip            = each.value.appliance_ip
  group_policy_id         = each.value.group_policy_id
  ipv6_enabled            = each.value.ipv6_enabled
  ipv6_prefix_assignments = each.value.ipv6_prefix_assignments
  name                    = each.value.name
  subnet                  = each.value.subnet
  vpn_nat_subnet          = each.value.vpn_nat_subnet
  depends_on              = [meraki_appliance_vlans_settings.appliance_vlans_settings]
}

resource "meraki_appliance_vlan_dhcp" "appliance_vlans_dhcp" {
  for_each                  = { for v in local.networks_networks_appliance_vlans : v.key => v }
  network_id                = each.value.network_id
  vlan_id                   = each.value.vlan_id
  dhcp_boot_options_enabled = each.value.dhcp_boot_options_enabled
  dhcp_handling             = each.value.dhcp_handling
  dhcp_lease_time           = each.value.dhcp_lease_time
  dhcp_options              = each.value.dhcp_options
  dns_nameservers           = each.value.dns_nameservers
  mandatory_dhcp_enabled    = each.value.mandatory_dhcp_enabled
  reserved_ip_ranges        = each.value.reserved_ip_ranges
  depends_on                = [meraki_appliance_vlan.appliance_vlans]
}
locals {
  networks_networks_appliance_vlans_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key           = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id    = meraki_network.network[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          vlans_enabled = try(length(network.appliance.vlans) > 0, false)
        } if try(length(network.appliance.vlans) > 0, false)
      ]
    ]
  ])
}

resource "meraki_appliance_vlans_settings" "appliance_vlans_settings" {
  for_each      = { for v in local.networks_networks_appliance_vlans_settings : v.key => v }
  network_id    = each.value.network_id
  vlans_enabled = each.value.vlans_enabled
  depends_on    = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_networks_appliance_vpn_bgp = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key             = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id      = meraki_network.network[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          enabled         = try(network.appliance.vpn_bgp.enabled, local.defaults.meraki.networks.appliance.vpn_bgp.enabled, null)
          as_number       = try(network.appliance.vpn_bgp.as_number, local.defaults.meraki.networks.appliance.vpn_bgp.as_number, null)
          ibgp_hold_timer = try(network.appliance.vpn_bgp.ibgp_hold_timer, local.defaults.meraki.networks.appliance.vpn_bgp.ibgp_hold_timer, null)
          neighbors = try(length(network.appliance.vpn_bgp.neighbors) == 0, true) ? null : [
            for neighbor in try(network.appliance.vpn_bgp.neighbors, []) : {
              ebgp_hold_time          = try(neighbor.ebgp_hold_time, local.defaults.meraki.networks.appliance.vpn_bgp.neighbors.ebgp_hold_time, null)
              ebgp_multihop           = try(neighbor.ebgp_multihop, local.defaults.meraki.networks.appliance.vpn_bgp.neighbors.ebgp_multihop, null)
              ip                      = try(neighbor.ip, local.defaults.meraki.networks.appliance.vpn_bgp.neighbors.ip, null)
              remote_as_number        = try(neighbor.remote_as_number, local.defaults.meraki.networks.appliance.vpn_bgp.neighbors.remote_as_number, null)
              allow_transit           = try(neighbor.allow_transit, local.defaults.meraki.networks.appliance.vpn_bgp.neighbors.allow_transit, null)
              authentication_password = try(neighbor.authentication_password, local.defaults.meraki.networks.appliance.vpn_bgp.neighbors.authentication_password, null)
              ipv6_address            = try(neighbor.ipv6_address, local.defaults.meraki.networks.appliance.vpn_bgp.neighbors.ipv6_address, null)
              next_hop_ip             = try(neighbor.next_hop_ip, local.defaults.meraki.networks.appliance.vpn_bgp.neighbors.next_hop_ip, null)
              receive_limit           = try(neighbor.receive_limit, local.defaults.meraki.networks.appliance.vpn_bgp.neighbors.receive_limit, null)
              source_interface        = try(neighbor.source_interface, local.defaults.meraki.networks.appliance.vpn_bgp.neighbors.source_interface, null)
              ttl_security_enabled    = try(neighbor.ttl_security_enabled, local.defaults.meraki.networks.appliance.vpn_bgp.neighbors.ttl_security_enabled, null)
            }
          ]
        } if try(network.appliance.vpn_bgp, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_vpn_bgp" "appliance_vpn_bgp" {
  for_each        = { for v in local.networks_networks_appliance_vpn_bgp : v.key => v }
  network_id      = each.value.network_id
  enabled         = each.value.enabled
  as_number       = each.value.as_number
  ibgp_hold_timer = each.value.ibgp_hold_timer
  neighbors       = each.value.neighbors
  depends_on      = [meraki_appliance_site_to_site_vpn.appliance_vpn_site_to_site_vpn]
}

locals {
  networks_networks_appliance_vpn_site_to_site_vpn = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = meraki_network.network[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          mode       = try(network.appliance.vpn_site_to_site_vpn.mode, local.defaults.meraki.networks.appliance.vpn_site_to_site_vpn.mode, null)
          subnets = try(length(network.appliance.vpn_site_to_site_vpn.subnets) == 0, true) ? null : [
            for subnet in try(network.appliance.vpn_site_to_site_vpn.subnets, []) : {
              local_subnet      = try(subnet.local_subnet, local.defaults.meraki.networks.appliance.vpn_site_to_site_vpn.subnets.local_subnet, null)
              nat_enabled       = try(subnet.nat_enabled, local.defaults.meraki.networks.appliance.vpn_site_to_site_vpn.subnets.nat_enabled, null)
              nat_remote_subnet = try(subnet.nat_remote_subnet, local.defaults.meraki.networks.appliance.vpn_site_to_site_vpn.subnets.nat_remote_subnet, null)
              use_vpn           = try(subnet.use_vpn, local.defaults.meraki.networks.appliance.vpn_site_to_site_vpn.subnets.use_vpn, null)
            }
          ]
          hubs = try(length(network.appliance.vpn_site_to_site_vpn.hubs) == 0, true) ? null : [
            for hub in try(network.appliance.vpn_site_to_site_vpn.hubs, []) : {
              use_default_route = try(hub.use_default_route, local.defaults.meraki.networks.appliance.vpn_site_to_site_vpn.hubs.use_default_route, null)
              hub_id            = meraki_network.network[format("%s/%s/%s", domain.name, organization.name, hub.hub_network_name)].id
            }
          ]
        } if try(network.appliance.vpn_site_to_site_vpn, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_site_to_site_vpn" "appliance_vpn_site_to_site_vpn" {
  for_each   = { for v in local.networks_networks_appliance_vpn_site_to_site_vpn : v.key => v }
  network_id = each.value.network_id
  mode       = each.value.mode
  hubs       = each.value.hubs
  subnets    = each.value.subnets
  depends_on = [meraki_network_device_claim.net_device_claim, meraki_appliance_single_lan.appliance_single_lan, meraki_appliance_vlan.appliance_vlans]
}

locals {
  networks_networks_appliance_warm_spare = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key          = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id   = meraki_network.network[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          spare_serial = try(meraki_device.device[format("%s/%s/%s/%s", domain.name, organization.name, network.name, network.appliance.warm_spare.spare_device)].serial, null)
          enabled      = try(network.appliance.warm_spare.enabled, local.defaults.meraki.networks.appliance.warm_spare.enabled, null)
          uplink_mode  = try(network.appliance.warm_spare.uplink_mode, local.defaults.meraki.networks.appliance.warm_spare.uplink_mode, null)
          virtual_ip1  = try(network.appliance.warm_spare.virtual_ip1, local.defaults.meraki.networks.appliance.warm_spare.virtual_ip1, null)
          virtual_ip2  = try(network.appliance.warm_spare.virtual_ip2, local.defaults.meraki.networks.appliance.warm_spare.virtual_ip2, null)
        } if try(network.appliance.warm_spare, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_warm_spare" "appliance_warm_spare" {
  for_each     = { for v in local.networks_networks_appliance_warm_spare : v.key => v }
  network_id   = each.value.network_id
  enabled      = each.value.enabled
  spare_serial = each.value.spare_serial
  uplink_mode  = each.value.uplink_mode
  virtual_ip1  = each.value.virtual_ip1
  virtual_ip2  = each.value.virtual_ip2
  depends_on   = [meraki_network_device_claim.net_device_claim]
}
