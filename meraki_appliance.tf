locals {
  networks_appliance_content_filtering = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                    = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id             = meraki_network.organizations_networks[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          allowed_url_patterns   = try(network.appliance.content_filtering.allowed_url_patterns, local.defaults.meraki.domains.organizations.networks.appliance.content_filtering.allowed_url_patterns, null)
          blocked_url_patterns   = try(network.appliance.content_filtering.blocked_url_patterns, local.defaults.meraki.domains.organizations.networks.appliance.content_filtering.blocked_url_patterns, null)
          blocked_url_categories = try(network.appliance.content_filtering.blocked_url_categories, local.defaults.meraki.domains.organizations.networks.appliance.content_filtering.blocked_url_categories, null)
          url_category_list_size = try(network.appliance.content_filtering.url_category_list_size, local.defaults.meraki.domains.organizations.networks.appliance.content_filtering.url_category_list_size, null)
        } if try(network.appliance.content_filtering, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_content_filtering" "networks_appliance_content_filtering" {
  for_each               = { for v in local.networks_appliance_content_filtering : v.key => v }
  network_id             = each.value.network_id
  allowed_url_patterns   = each.value.allowed_url_patterns
  blocked_url_patterns   = each.value.blocked_url_patterns
  blocked_url_categories = each.value.blocked_url_categories
  url_category_list_size = each.value.url_category_list_size
  depends_on             = [meraki_network_device_claim.networks_devices_claim]
}

locals {
  networks_appliance_firewall_firewalled_services = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for appliance_firewall_firewalled_service in try(network.appliance.firewall.firewalled_services, []) : {
            key         = format("%s/%s/%s/%s", domain.name, organization.name, network.name, appliance_firewall_firewalled_service.service_name)
            network_id  = meraki_network.organizations_networks[format("%s/%s/%s", domain.name, organization.name, network.name)].id
            access      = try(appliance_firewall_firewalled_service.access, local.defaults.meraki.domains.organizations.networks.appliance.firewall.firewalled_services.access, null)
            allowed_ips = try(appliance_firewall_firewalled_service.allowed_ips, local.defaults.meraki.domains.organizations.networks.appliance.firewall.firewalled_services.allowed_ips, null)
            service     = try(appliance_firewall_firewalled_service.service_name, local.defaults.meraki.domains.organizations.networks.appliance.firewall.firewalled_services.service_name, null)
          }
        ]
      ]
    ]
  ])
}

resource "meraki_appliance_firewalled_service" "networks_appliance_firewall_firewalled_services" {
  for_each    = { for v in local.networks_appliance_firewall_firewalled_services : v.key => v }
  network_id  = each.value.network_id
  access      = each.value.access
  allowed_ips = each.value.allowed_ips
  service     = each.value.service
  depends_on  = [meraki_network_device_claim.networks_devices_claim]
}

locals {
  networks_appliance_firewall_inbound_firewall_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = meraki_network.organizations_networks[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          rules = try(length(network.appliance.firewall.inbound_firewall_rules.rules) == 0, true) ? null : [
            for rule in try(network.appliance.firewall.inbound_firewall_rules.rules, []) : {
              comment        = try(rule.comment, local.defaults.meraki.domains.organizations.networks.appliance.firewall.inbound_firewall_rules.rules.comment, null)
              dest_cidr      = try(rule.destination_cidr, local.defaults.meraki.domains.organizations.networks.appliance.firewall.inbound_firewall_rules.rules.destination_cidr, null)
              dest_port      = try(rule.destination_port, local.defaults.meraki.domains.organizations.networks.appliance.firewall.inbound_firewall_rules.rules.destination_port, null)
              policy         = try(rule.policy, local.defaults.meraki.domains.organizations.networks.appliance.firewall.inbound_firewall_rules.rules.policy, null)
              protocol       = try(rule.protocol, local.defaults.meraki.domains.organizations.networks.appliance.firewall.inbound_firewall_rules.rules.protocol, null)
              src_cidr       = try(rule.source_cidr, local.defaults.meraki.domains.organizations.networks.appliance.firewall.inbound_firewall_rules.rules.source_cidr, null)
              src_port       = try(rule.source_port, local.defaults.meraki.domains.organizations.networks.appliance.firewall.inbound_firewall_rules.rules.source_port, null)
              syslog_enabled = try(rule.syslog, local.defaults.meraki.domains.organizations.networks.appliance.firewall.inbound_firewall_rules.rules.syslog, null)
            }
          ]
          syslog_default_rule = try(network.appliance.firewall.inbound_firewall_rules.syslog_default_rule, local.defaults.meraki.domains.organizations.networks.appliance.firewall.inbound_firewall_rules.syslog_default_rule, null)
        } if length(try(network.appliance.firewall.inbound_firewall_rules.rules, [])) > 0
      ]
    ]
  ])
}

resource "meraki_appliance_inbound_firewall_rules" "networks_appliance_firewall_inbound_firewall_rules" {
  for_each            = { for v in local.networks_appliance_firewall_inbound_firewall_rules : v.key => v }
  network_id          = each.value.network_id
  rules               = each.value.rules
  syslog_default_rule = each.value.syslog_default_rule
  depends_on          = [meraki_network_device_claim.networks_devices_claim]
}

locals {
  networks_appliance_firewall_l3_firewall_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                 = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id          = meraki_network.organizations_networks[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          syslog_default_rule = try(network.appliance.firewall.l3_firewall_rules.syslog_default_rule, local.defaults.meraki.domains.organizations.networks.appliance.firewall.l3_firewall_rules.syslog_default_rule, null)
          rules = try(length(network.appliance.firewall.l3_firewall_rules.rules) == 0, true) ? null : [
            for rule in try(network.appliance.firewall.l3_firewall_rules.rules, []) : {
              comment        = try(rule.comment, local.defaults.meraki.domains.organizations.networks.appliance.firewall.l3_firewall_rules.rules.comment, null)
              dest_cidr      = try(rule.destination_cidr, local.defaults.meraki.domains.organizations.networks.appliance.firewall.l3_firewall_rules.rules.destination_cidr, null)
              dest_port      = try(rule.destination_port, local.defaults.meraki.domains.organizations.networks.appliance.firewall.l3_firewall_rules.rules.destination_port, null)
              policy         = try(rule.policy, local.defaults.meraki.domains.organizations.networks.appliance.firewall.l3_firewall_rules.rules.policy, null)
              protocol       = try(rule.protocol, local.defaults.meraki.domains.organizations.networks.appliance.firewall.l3_firewall_rules.rules.protocol, null)
              src_cidr       = try(rule.source_cidr, local.defaults.meraki.domains.organizations.networks.appliance.firewall.l3_firewall_rules.rules.source_cidr, null)
              src_port       = try(rule.source_port, local.defaults.meraki.domains.organizations.networks.appliance.firewall.l3_firewall_rules.rules.source_port, null)
              syslog_enabled = try(rule.syslog, local.defaults.meraki.domains.organizations.networks.appliance.firewall.l3_firewall_rules.rules.syslog, null)
            }
          ]
        }
      ]
    ]
  ])
}

resource "meraki_appliance_l3_firewall_rules" "networks_appliance_firewall_l3_firewall_rules" {
  for_each            = { for v in local.networks_appliance_firewall_l3_firewall_rules : v.key => v }
  network_id          = each.value.network_id
  syslog_default_rule = each.value.syslog_default_rule
  rules               = each.value.rules
  depends_on          = [meraki_network_device_claim.networks_devices_claim]
}

locals {
  networks_appliance_firewall_l7_firewall_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = meraki_network.organizations_networks[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          rules = try(length(network.appliance.firewall.l7_firewall_rules) == 0, true) ? null : [
            for rule in try(network.appliance.firewall.l7_firewall_rules, []) : {
              policy = try(rule.policy, local.defaults.meraki.domains.organizations.networks.appliance.firewall.l7_firewall_rules.policy, null)
              type   = try(rule.type, local.defaults.meraki.domains.organizations.networks.appliance.firewall.l7_firewall_rules.type, null)
              value  = try(rule.value, local.defaults.meraki.domains.organizations.networks.appliance.firewall.l7_firewall_rules.value, null)
            }
          ]
        } if length(try(network.appliance.firewall.l7_firewall_rules, [])) > 0
      ]
    ]
  ])
}

resource "meraki_appliance_l7_firewall_rules" "networks_appliance_firewall_l7_firewall_rules" {
  for_each   = { for v in local.networks_appliance_firewall_l7_firewall_rules : v.key => v }
  network_id = each.value.network_id
  rules      = each.value.rules
  depends_on = [meraki_network_device_claim.networks_devices_claim]
}

locals {
  networks_appliance_firewall_one_to_many_nat_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = meraki_network.organizations_networks[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          rules = try(length(network.appliance.firewall.one_to_many_nat_rules) == 0, true) ? null : [
            for rule in try(network.appliance.firewall.one_to_many_nat_rules, []) : {
              public_ip = try(rule.public_ip, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_many_nat_rules.public_ip, null)
              uplink    = try(rule.uplink, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_many_nat_rules.uplink, null)
              port_rules = try(length(rule.port_rules) == 0, true) ? null : [
                for pr in try(rule.port_rules, []) : {
                  name        = try(pr.name, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_many_nat_rules.port_rules.name, null)
                  allowed_ips = try(pr.allowed_ips, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_many_nat_rules.port_rules.allowed_ips, null)
                  local_ip    = try(pr.local_ip, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_many_nat_rules.port_rules.local_ip, null)
                  local_port  = try(pr.local_port, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_many_nat_rules.port_rules.local_port, null)
                  protocol    = try(pr.protocol, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_many_nat_rules.port_rules.protocol, null)
                  public_port = try(pr.public_port, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_many_nat_rules.port_rules.public_port, null)
                }
              ]
            }
          ]
        } if length(try(network.appliance.firewall.one_to_many_nat_rules, [])) > 0
      ]
    ]
  ])
}

resource "meraki_appliance_one_to_many_nat_rules" "networks_appliance_firewall_one_to_many_nat_rules" {
  for_each   = { for v in local.networks_appliance_firewall_one_to_many_nat_rules : v.key => v }
  network_id = each.value.network_id
  rules      = each.value.rules
  depends_on = [meraki_network_device_claim.networks_devices_claim]
}

locals {
  networks_appliance_firewall_one_to_one_nat_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = meraki_network.organizations_networks[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          rules = try(length(network.appliance.firewall.one_to_one_nat_rules) == 0, true) ? null : [
            for rule in try(network.appliance.firewall.one_to_one_nat_rules, []) : {
              lan_ip    = try(rule.lan_ip, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_one_nat_rules.lan_ip, null)
              public_ip = try(rule.public_ip, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_one_nat_rules.public_ip, null)
              uplink    = try(rule.uplink, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_one_nat_rules.uplink, null)
              name      = try(rule.name, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_one_nat_rules.name, null)
              allowed_inbound = try(length(rule.allowed_inbound) == 0, true) ? null : [
                for ai in try(rule.allowed_inbound, []) : {
                  allowed_ips       = try(ai.allowed_ips, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_one_nat_rules.allowed_inbound.allowed_ips, null)
                  destination_ports = try(ai.destination_ports, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_one_nat_rules.allowed_inbound.destination_ports, null)
                  protocol          = try(ai.protocol, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_one_nat_rules.allowed_inbound.protocol, null)
                }
              ]
            }
          ]
        } if length(try(network.appliance.firewall.one_to_one_nat_rules, [])) > 0
      ]
    ]
  ])
}

resource "meraki_appliance_one_to_one_nat_rules" "networks_appliance_firewall_one_to_one_nat_rules" {
  for_each   = { for v in local.networks_appliance_firewall_one_to_one_nat_rules : v.key => v }
  network_id = each.value.network_id
  rules      = each.value.rules
  depends_on = [meraki_network_device_claim.networks_devices_claim]
}

locals {
  networks_appliance_firewall_port_forwarding_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = meraki_network.organizations_networks[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          rules = try(length(network.appliance.firewall.port_forwarding_rules) == 0, true) ? null : [
            for rule in try(network.appliance.firewall.port_forwarding_rules, []) : {
              allowed_ips = try(rule.allowed_ips, local.defaults.meraki.domains.organizations.networks.appliance.firewall.port_forwarding_rules.allowed_ips, null)
              lan_ip      = try(rule.lan_ip, local.defaults.meraki.domains.organizations.networks.appliance.firewall.port_forwarding_rules.lan_ip, null)
              local_port  = try(rule.local_port, local.defaults.meraki.domains.organizations.networks.appliance.firewall.port_forwarding_rules.local_port, null)
              protocol    = try(rule.protocol, local.defaults.meraki.domains.organizations.networks.appliance.firewall.port_forwarding_rules.protocol, null)
              public_port = try(rule.public_port, local.defaults.meraki.domains.organizations.networks.appliance.firewall.port_forwarding_rules.public_port, null)
              name        = try(rule.name, local.defaults.meraki.domains.organizations.networks.appliance.firewall.port_forwarding_rules.name, null)
              uplink      = try(rule.uplink, local.defaults.meraki.domains.organizations.networks.appliance.firewall.port_forwarding_rules.uplink, null)
            }
          ]
        } if length(try(network.appliance.firewall.port_forwarding_rules, [])) > 0
      ]
    ]
  ])
}

resource "meraki_appliance_port_forwarding_rules" "networks_appliance_firewall_port_forwarding_rules" {
  for_each   = { for v in local.networks_appliance_firewall_port_forwarding_rules : v.key => v }
  network_id = each.value.network_id
  rules      = each.value.rules
  depends_on = [meraki_network_device_claim.networks_devices_claim]
}

locals {
  networks_appliance_firewall_settings_spoofing_protection_ip_source_guard_mode = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                                      = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id                               = meraki_network.organizations_networks[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          spoofing_protection_ip_source_guard_mode = try(network.appliance.firewall.settings_spoofing_protection_ip_source_guard_mode, local.defaults.meraki.domains.organizations.networks.appliance.firewall.settings_spoofing_protection_ip_source_guard_mode, null)
        } if try(network.appliance.firewall.settings_spoofing_protection_ip_source_guard_mode, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_firewall_settings" "networks_appliance_firewall_settings_spoofing_protection_ip_source_guard_mode" {
  for_each                                 = { for v in local.networks_appliance_firewall_settings_spoofing_protection_ip_source_guard_mode : v.key => v }
  network_id                               = each.value.network_id
  spoofing_protection_ip_source_guard_mode = each.value.spoofing_protection_ip_source_guard_mode
  depends_on                               = [meraki_network_device_claim.networks_devices_claim]
}

locals {
  networks_appliance_ports = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for appliance_port in try(network.appliance.ports, []) : {
            key                   = format("%s/%s/%s/%s", domain.name, organization.name, network.name, appliance_port.port_id)
            network_id            = meraki_network.organizations_networks[format("%s/%s/%s", domain.name, organization.name, network.name)].id
            enabled               = try(appliance_port.enabled, local.defaults.meraki.domains.organizations.networks.appliance_ports.enabled, null)
            drop_untagged_traffic = try(appliance_port.drop_untagged_traffic, local.defaults.meraki.domains.organizations.networks.appliance_ports.drop_untagged_traffic, null)
            type                  = try(appliance_port.type, local.defaults.meraki.domains.organizations.networks.appliance_ports.type, null)
            vlan                  = try(appliance_port.vlan, local.defaults.meraki.domains.organizations.networks.appliance_ports.vlan, null)
            allowed_vlans         = try(appliance_port.allowed_vlans, local.defaults.meraki.domains.organizations.networks.appliance_ports.allowed_vlans, null)
            access_policy         = try(appliance_port.access_policy, local.defaults.meraki.domains.organizations.networks.appliance_ports.access_policy, null)
            port_id               = try(appliance_port.port_id, local.defaults.meraki.domains.organizations.networks.appliance_ports.port_id, null)
          }
        ]
      ]
    ]
  ])
}

resource "meraki_appliance_port" "networks_appliance_ports" {
  for_each              = { for v in local.networks_appliance_ports : v.key => v }
  network_id            = each.value.network_id
  enabled               = each.value.enabled
  drop_untagged_traffic = each.value.drop_untagged_traffic
  type                  = each.value.type
  vlan                  = each.value.vlan
  allowed_vlans         = each.value.allowed_vlans
  access_policy         = each.value.access_policy
  port_id               = each.value.port_id
  depends_on            = [meraki_network_device_claim.networks_devices_claim, meraki_appliance_vlan.networks_appliance_vlans, meraki_appliance_single_lan.networks_appliance_single_lan]
}

locals {
  networks_appliance_security_intrusion = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                              = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id                       = meraki_network.organizations_networks[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          mode                             = try(network.appliance.security_intrusion.mode, local.defaults.meraki.domains.organizations.networks.appliance.security_intrusion.mode, null)
          ids_rulesets                     = try(network.appliance.security_intrusion.ids_rulesets, local.defaults.meraki.domains.organizations.networks.appliance.security_intrusion.ids_rulesets, null)
          protected_networks_use_default   = try(network.appliance.security_intrusion.protected_networks.use_default, local.defaults.meraki.domains.organizations.networks.appliance_security_intrusion.protected_networks.use_default, null)
          protected_networks_included_cidr = try(network.appliance.security_intrusion.protected_networks.included_cidr, local.defaults.meraki.domains.organizations.networks.appliance_security_intrusion.protected_networks.included_cidr, null)
          protected_networks_excluded_cidr = try(network.appliance.security_intrusion.protected_networks.excluded_cidr, local.defaults.meraki.domains.organizations.networks.appliance_security_intrusion.protected_networks.excluded_cidr, null)
        } if try(network.appliance.security_intrusion, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_network_security_intrusion" "networks_appliance_security_intrusion" {
  for_each                         = { for v in local.networks_appliance_security_intrusion : v.key => v }
  network_id                       = each.value.network_id
  mode                             = each.value.mode
  ids_rulesets                     = each.value.ids_rulesets
  protected_networks_use_default   = each.value.protected_networks_use_default
  protected_networks_included_cidr = each.value.protected_networks_included_cidr
  protected_networks_excluded_cidr = each.value.protected_networks_excluded_cidr
  depends_on                       = [meraki_network_device_claim.networks_devices_claim]
}

locals {
  networks_appliance_security_malware = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = meraki_network.organizations_networks[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          mode       = try(network.appliance.security_malware.mode, local.defaults.meraki.domains.organizations.networks.appliance.security_malware.mode, null)
          allowed_urls = try(length(network.appliance.security_malware.allowed_urls) == 0, true) ? null : [
            for allowed_url in try(network.appliance.security_malware.allowed_urls, []) : {
              url     = try(allowed_url.url, local.defaults.meraki.domains.organizations.networks.appliance.security_malware.allowed_urls.url, null)
              comment = try(allowed_url.comment, local.defaults.meraki.domains.organizations.networks.appliance.security_malware.allowed_urls.comment, null)
            }
          ]
          allowed_files = try(length(network.appliance.security_malware.allowed_files) == 0, true) ? null : [
            for allowed_file in try(network.appliance.security_malware.allowed_files, []) : {
              sha256  = try(allowed_file.sha256, local.defaults.meraki.domains.organizations.networks.appliance.security_malware.allowed_files.sha256, null)
              comment = try(allowed_file.comment, local.defaults.meraki.domains.organizations.networks.appliance.security_malware.allowed_files.comment, null)
            }
          ]
        } if try(network.appliance.security_malware, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_security_malware" "networks_appliance_security_malware" {
  for_each      = { for v in local.networks_appliance_security_malware : v.key => v }
  network_id    = each.value.network_id
  mode          = each.value.mode
  allowed_urls  = each.value.allowed_urls
  allowed_files = each.value.allowed_files
  depends_on    = [meraki_network_device_claim.networks_devices_claim]
}

locals {
  networks_appliance_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                    = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id             = meraki_network.organizations_networks[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          client_tracking_method = try(network.appliance.settings.client_tracking_method, local.defaults.meraki.domains.organizations.networks.appliance.settings.client_tracking_method, null)
          deployment_mode        = try(network.appliance.settings.deployment_mode, local.defaults.meraki.domains.organizations.networks.appliance.settings.deployment_mode, null)
          dynamic_dns_prefix     = try(network.appliance.settings.dynamic_dns.prefix, local.defaults.meraki.domains.organizations.networks.appliance.settings.dynamic_dns.prefix, null)
          dynamic_dns_enabled    = try(network.appliance.settings.dynamic_dns.enabled, local.defaults.meraki.domains.organizations.networks.appliance.settings.dynamic_dns.enabled, null)
        } if try(network.appliance.settings, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_settings" "networks_appliance_settings" {
  for_each               = { for v in local.networks_appliance_settings : v.key => v }
  network_id             = each.value.network_id
  client_tracking_method = each.value.client_tracking_method
  deployment_mode        = each.value.deployment_mode
  dynamic_dns_prefix     = each.value.dynamic_dns_prefix
  dynamic_dns_enabled    = each.value.dynamic_dns_enabled
  depends_on             = [meraki_network_device_claim.networks_devices_claim]
}

locals {
  networks_appliance_single_lan = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key          = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id   = meraki_network.organizations_networks[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          subnet       = try(network.appliance.single_lan.subnet, local.defaults.meraki.domains.organizations.networks.appliance.single_lan.subnet, null)
          appliance_ip = try(network.appliance.single_lan.appliance_ip, local.defaults.meraki.domains.organizations.networks.appliance.single_lan.appliance_ip, null)
          ipv6_enabled = try(network.appliance.single_lan.ipv6.enabled, local.defaults.meraki.domains.organizations.networks.appliance.single_lan.ipv6.enabled, null)
          ipv6_prefix_assignments = try(length(network.appliance.single_lan.ipv6.prefix_assignments) == 0, true) ? null : [
            for ipv6_prefix_assignment in try(network.appliance.single_lan.ipv6.prefix_assignments, []) : {
              autonomous           = try(ipv6_prefix_assignment.autonomous, local.defaults.meraki.domains.organizations.networks.appliance.single_lan.ipv6.prefix_assignments.autonomous, null)
              static_prefix        = try(ipv6_prefix_assignment.static_prefix, local.defaults.meraki.domains.organizations.networks.appliance.single_lan.ipv6.prefix_assignments.static_prefix, null)
              static_appliance_ip6 = try(ipv6_prefix_assignment.static_appliance_ip6, local.defaults.meraki.domains.organizations.networks.appliance.single_lan.ipv6.prefix_assignments.static_appliance_ip6, null)
              origin_type          = try(ipv6_prefix_assignment.origin.type, local.defaults.meraki.domains.organizations.networks.appliance.single_lan.ipv6.prefix_assignments.origin.type, null)
              origin_interfaces    = try(ipv6_prefix_assignment.origin.interfaces, local.defaults.meraki.domains.organizations.networks.appliance.single_lan.ipv6.prefix_assignments.origin.interfaces, null)
            }
          ]
          mandatory_dhcp_enabled = try(network.appliance.single_lan.mandatory_dhcp, local.defaults.meraki.domains.organizations.networks.appliance.single_lan.mandatory_dhcp, null)
        } if try(network.appliance.single_lan, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_single_lan" "networks_appliance_single_lan" {
  for_each                = { for v in local.networks_appliance_single_lan : v.key => v }
  network_id              = each.value.network_id
  subnet                  = each.value.subnet
  appliance_ip            = each.value.appliance_ip
  ipv6_enabled            = each.value.ipv6_enabled
  ipv6_prefix_assignments = each.value.ipv6_prefix_assignments
  mandatory_dhcp_enabled  = each.value.mandatory_dhcp_enabled
  depends_on              = [meraki_network_device_claim.networks_devices_claim]
}

locals {
  networks_appliance_vlans = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for appliance_vlan in try(network.appliance.vlans, []) : {
            key             = format("%s/%s/%s/%s", domain.name, organization.name, network.name, appliance_vlan.vlan_id)
            network_id      = meraki_network.organizations_networks[format("%s/%s/%s", domain.name, organization.name, network.name)].id
            vlan_id         = try(appliance_vlan.vlan_id, local.defaults.meraki.domains.organizations.networks.appliance.vlans.vlan_id, null)
            appliance_ip    = try(appliance_vlan.appliance_ip, local.defaults.meraki.domains.organizations.networks.appliance.vlans.appliance_ip, null)
            group_policy_id = try(appliance_vlan.group_policy_id, local.defaults.meraki.domains.organizations.networks.appliance.vlans.group_policy_id, null)
            ipv6_enabled    = try(appliance_vlan.ipv6.enabled, local.defaults.meraki.domains.organizations.networks.appliance.vlans.ipv6.enabled, null)
            ipv6_prefix_assignments = try(length(appliance_vlan.ipv6.prefix_assignments) == 0, true) ? null : [
              for ipv6_prefix_assignment in try(appliance_vlan.ipv6.prefix_assignments, []) : {
                autonomous           = try(ipv6_prefix_assignment.autonomous, local.defaults.meraki.domains.organizations.networks.appliance.single_lan.ipv6.prefix_assignments.autonomous, null)
                static_prefix        = try(ipv6_prefix_assignment.static_prefix, local.defaults.meraki.domains.organizations.networks.appliance.single_lan.ipv6.prefix_assignments.static_prefix, null)
                static_appliance_ip6 = try(ipv6_prefix_assignment.static_appliance_ip6, local.defaults.meraki.domains.organizations.networks.appliance.single_lan.ipv6.prefix_assignments.static_appliance_ip6, null)
                origin_type          = try(ipv6_prefix_assignment.origin.type, local.defaults.meraki.domains.organizations.networks.appliance.single_lan.ipv6.prefix_assignments.origin.type, null)
                origin_interfaces    = try(ipv6_prefix_assignment.origin.interfaces, local.defaults.meraki.domains.organizations.networks.appliance.single_lan.ipv6.prefix_assignments.origin.interfaces, null)
              }
            ]
            name                      = try(appliance_vlan.name, local.defaults.meraki.domains.organizations.networks.appliance.vlans.name, null)
            subnet                    = try(appliance_vlan.subnet, local.defaults.meraki.domains.organizations.networks.appliance.vlans.subnet, null)
            vpn_nat_subnet            = try(appliance_vlan.vpn_nat_subnet, local.defaults.meraki.domains.organizations.networks.appliance.vlans.vpn_nat_subnet, null)
            dhcp_boot_options_enabled = try(appliance_vlan.dhcp_boot_options, local.defaults.meraki.domains.organizations.networks.appliance.vlans.dhcp_boot_options, null)
            dhcp_handling             = try(appliance_vlan.dhcp_handling, local.defaults.meraki.domains.organizations.networks.appliance.vlans.dhcp_handling, null)
            dhcp_lease_time           = try(appliance_vlan.dhcp_lease_time, local.defaults.meraki.domains.organizations.networks.appliance.vlans.dhcp_lease_time, null)
            dhcp_options = try(length(appliance_vlan.dhcp_options) == 0, true) ? null : [
              for dhcp_option in try(appliance_vlan.dhcp_options, []) : {
                code  = try(dhcp_option.code, local.defaults.meraki.domains.organizations.networks.appliance.vlans.dhcp_options.code, null)
                type  = try(dhcp_option.type, local.defaults.meraki.domains.organizations.networks.appliance.vlans.dhcp_options.type, null)
                value = try(dhcp_option.value, local.defaults.meraki.domains.organizations.networks.appliance.vlans.dhcp_options.value, null)
              }
            ]
            dns_nameservers        = try(appliance_vlan.dns_nameservers, local.defaults.meraki.domains.organizations.networks.appliance.vlans.dns_nameservers, null)
            mandatory_dhcp_enabled = try(appliance_vlan.mandatory_dhcp, local.defaults.meraki.domains.organizations.networks.appliance.vlans.mandatory_dhcp, null)
            reserved_ip_ranges = try(length(appliance_vlan.reserved_ip_ranges) == 0, true) ? null : [
              for reserved_ip_range in try(appliance_vlan.reserved_ip_ranges, []) : {
                start   = try(reserved_ip_range.start, local.defaults.meraki.domains.organizations.networks.appliance.vlans.reserved_ip_ranges.start, null)
                end     = try(reserved_ip_range.end, local.defaults.meraki.domains.organizations.networks.appliance.vlans.reserved_ip_ranges.end, null)
                comment = try(reserved_ip_range.comment, local.defaults.meraki.domains.organizations.networks.appliance.vlans.reserved_ip_ranges.comment, null)
              }
            ]
          }
        ]
      ]
    ]
  ])
}

resource "meraki_appliance_vlan" "networks_appliance_vlans" {
  for_each                = { for v in local.networks_appliance_vlans : v.key => v }
  network_id              = each.value.network_id
  vlan_id                 = each.value.vlan_id
  appliance_ip            = each.value.appliance_ip
  group_policy_id         = each.value.group_policy_id
  ipv6_enabled            = each.value.ipv6_enabled
  ipv6_prefix_assignments = each.value.ipv6_prefix_assignments
  name                    = each.value.name
  subnet                  = each.value.subnet
  vpn_nat_subnet          = each.value.vpn_nat_subnet
  depends_on              = [meraki_appliance_vlans_settings.networks_appliance_vlans_settings]
}

resource "meraki_appliance_vlan_dhcp" "networks_appliance_vlans_dhcp" {
  for_each                  = { for v in local.networks_appliance_vlans : v.key => v }
  network_id                = each.value.network_id
  vlan_id                   = each.value.vlan_id
  dhcp_boot_options_enabled = each.value.dhcp_boot_options_enabled
  dhcp_handling             = each.value.dhcp_handling
  dhcp_lease_time           = each.value.dhcp_lease_time
  dhcp_options              = each.value.dhcp_options
  dns_nameservers           = each.value.dns_nameservers
  mandatory_dhcp_enabled    = each.value.mandatory_dhcp_enabled
  reserved_ip_ranges        = each.value.reserved_ip_ranges
  depends_on                = [meraki_appliance_vlan.networks_appliance_vlans]
}

locals {
  networks_appliance_vlans_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key           = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id    = meraki_network.organizations_networks[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          vlans_enabled = try(length(network.appliance.vlans) > 0, false)
        } if try(length(network.appliance.vlans) > 0, false)
      ]
    ]
  ])
}

resource "meraki_appliance_vlans_settings" "networks_appliance_vlans_settings" {
  for_each      = { for v in local.networks_appliance_vlans_settings : v.key => v }
  network_id    = each.value.network_id
  vlans_enabled = each.value.vlans_enabled
  depends_on    = [meraki_network_device_claim.networks_devices_claim]
}

locals {
  networks_appliance_vpn_bgp = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key             = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id      = meraki_network.organizations_networks[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          enabled         = try(network.appliance.vpn_bgp.enabled, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.enabled, null)
          as_number       = try(network.appliance.vpn_bgp.as_number, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.as_number, null)
          ibgp_hold_timer = try(network.appliance.vpn_bgp.ibgp_hold_timer, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.ibgp_hold_timer, null)
          neighbors = try(length(network.appliance.vpn_bgp.neighbors) == 0, true) ? null : [
            for neighbor in try(network.appliance.vpn_bgp.neighbors, []) : {
              ebgp_hold_time          = try(neighbor.ebgp_hold_time, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.neighbors.ebgp_hold_time, null)
              ebgp_multihop           = try(neighbor.ebgp_multihop, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.neighbors.ebgp_multihop, null)
              ip                      = try(neighbor.ip, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.neighbors.ip, null)
              remote_as_number        = try(neighbor.remote_as_number, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.neighbors.remote_as_number, null)
              allow_transit           = try(neighbor.allow_transit, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.neighbors.allow_transit, null)
              authentication_password = try(neighbor.authentication_password, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.neighbors.authentication_password, null)
              ipv6_address            = try(neighbor.ipv6_address, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.neighbors.ipv6_address, null)
              next_hop_ip             = try(neighbor.next_hop_ip, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.neighbors.next_hop_ip, null)
              receive_limit           = try(neighbor.receive_limit, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.neighbors.receive_limit, null)
              source_interface        = try(neighbor.source_interface, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.neighbors.source_interface, null)
              ttl_security_enabled    = try(neighbor.ttl_security_enabled, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.neighbors.ttl_security_enabled, null)
            }
          ]
        } if try(network.appliance.vpn_bgp, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_vpn_bgp" "networks_appliance_vpn_bgp" {
  for_each        = { for v in local.networks_appliance_vpn_bgp : v.key => v }
  network_id      = each.value.network_id
  enabled         = each.value.enabled
  as_number       = each.value.as_number
  ibgp_hold_timer = each.value.ibgp_hold_timer
  neighbors       = each.value.neighbors
  depends_on      = [meraki_appliance_site_to_site_vpn.networks_appliance_vpn_site_to_site_vpn]
}

locals {
  networks_appliance_vpn_site_to_site_vpn = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = meraki_network.organizations_networks[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          mode       = try(network.appliance.vpn_site_to_site_vpn.mode, local.defaults.meraki.domains.organizations.networks.appliance.vpn_site_to_site_vpn.mode, null)
          subnets = try(length(network.appliance.vpn_site_to_site_vpn.subnets) == 0, true) ? null : [
            for subnet in try(network.appliance.vpn_site_to_site_vpn.subnets, []) : {
              local_subnet      = try(subnet.local_subnet, local.defaults.meraki.domains.organizations.networks.appliance.vpn_site_to_site_vpn.subnets.local_subnet, null)
              nat_enabled       = try(subnet.nat.enabled, local.defaults.meraki.domains.organizations.networks.appliance.vpn_site_to_site_vpn.subnets.nat.enabled, null)
              nat_remote_subnet = try(subnet.nat.remote_subnet, local.defaults.meraki.domains.organizations.networks.appliance.vpn_site_to_site_vpn.subnets.nat.remote_subnet, null)
              use_vpn           = try(subnet.use_vpn, local.defaults.meraki.domains.organizations.networks.appliance.vpn_site_to_site_vpn.subnets.use_vpn, null)
            }
          ]
          hubs = try(length(network.appliance.vpn_site_to_site_vpn.hubs) == 0, true) ? null : [
            for hub in try(network.appliance.vpn_site_to_site_vpn.hubs, []) : {
              use_default_route = try(hub.use_default_route, local.defaults.meraki.domains.organizations.networks.appliance.vpn_site_to_site_vpn.hubs.use_default_route, null)
              hub_id            = meraki_network.organizations_networks[format("%s/%s/%s", domain.name, organization.name, hub.hub_network_name)].id
            }
          ]
        } if try(network.appliance.vpn_site_to_site_vpn, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_site_to_site_vpn" "networks_appliance_vpn_site_to_site_vpn" {
  for_each   = { for v in local.networks_appliance_vpn_site_to_site_vpn : v.key => v }
  network_id = each.value.network_id
  mode       = each.value.mode
  hubs       = each.value.hubs
  subnets    = each.value.subnets
  depends_on = [meraki_network_device_claim.networks_devices_claim, meraki_appliance_single_lan.networks_appliance_single_lan, meraki_appliance_vlan.networks_appliance_vlans]
}

locals {
  networks_appliance_warm_spare = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key          = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id   = meraki_network.organizations_networks[format("%s/%s/%s", domain.name, organization.name, network.name)].id
          spare_serial = try(meraki_device.devices[format("%s/%s/%s/%s", domain.name, organization.name, network.name, network.appliance.warm_spare.spare_device)].serial, null)
          enabled      = try(network.appliance.warm_spare.enabled, local.defaults.meraki.domains.organizations.networks.appliance.warm_spare.enabled, null)
          uplink_mode  = try(network.appliance.warm_spare.uplink_mode, local.defaults.meraki.domains.organizations.networks.appliance.warm_spare.uplink_mode, null)
          virtual_ip1  = try(network.appliance.warm_spare.virtual_ip1, local.defaults.meraki.domains.organizations.networks.appliance.warm_spare.virtual_ip1, null)
          virtual_ip2  = try(network.appliance.warm_spare.virtual_ip2, local.defaults.meraki.domains.organizations.networks.appliance.warm_spare.virtual_ip2, null)
        } if try(network.appliance.warm_spare, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_warm_spare" "networks_appliance_warm_spare" {
  for_each     = { for v in local.networks_appliance_warm_spare : v.key => v }
  network_id   = each.value.network_id
  enabled      = each.value.enabled
  spare_serial = each.value.spare_serial
  uplink_mode  = each.value.uplink_mode
  virtual_ip1  = each.value.virtual_ip1
  virtual_ip2  = each.value.virtual_ip2
  depends_on   = [meraki_network_device_claim.networks_devices_claim]
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

          wan_traffic_uplink_preferences = [for sdwan_internet_policy in try(network.appliance.sdwan_internet_policies, []) : {
            fail_over_criterion = try(sdwan_internet_policy.fail_over_criterion, local.defaults.meraki.networks.networks_appliance_sdwan_internet_policies.fail_over_criterion, null)
            preferred_uplink    = try(sdwan_internet_policy.preferred_uplink, local.defaults.meraki.networks.networks_appliance_sdwan_internet_policies.preferred_uplink, null)

            builtin_performance_class_name = try(sdwan_internet_policy.performance_class.builtin_performance_class_name, local.defaults.meraki.networks.networks_appliance_sdwan_internet_policies.performance_class.builtin_performance_class_name, null)
            custom_performance_class_id    = try(sdwan_internet_policy.performance_class.custom_performance_class_id, local.defaults.meraki.networks.networks_appliance_sdwan_internet_policies.performance_class.custom_performance_class_id, null)
            performance_class_type         = try(sdwan_internet_policy.performance_class.type, local.defaults.meraki.networks.networks_appliance_sdwan_internet_policies.performance_class.type, null)

            traffic_filters = [for traffic_filter in try(sdwan_internet_policy.traffic_filters, []) : {
              type = try(traffic_filter.type, local.defaults.meraki.networks.networks_appliance_sdwan_internet_policies.traffic_filters.type, null)

              protocol = try(traffic_filter.value.protocol, local.defaults.meraki.networks.networks_appliance_sdwan_internet_policies.traffic_filters.value.protocol, null)

              destination_cidr         = try(traffic_filter.value.destination.cidr, local.defaults.meraki.networks.networks_appliance_sdwan_internet_policies.traffic_filters.value.destination.cidr, null)
              destination_port         = try(traffic_filter.value.destination.port, local.defaults.meraki.networks.networks_appliance_sdwan_internet_policies.traffic_filters.value.destination.port, null)
              destination_applications = try(traffic_filter.value.destination.applications, local.defaults.meraki.networks.networks_appliance_sdwan_internet_policies.traffic_filters.value.destination.applications, null)

              source_cidr = try(traffic_filter.value.source.cidr, local.defaults.meraki.networks.networks_appliance_sdwan_internet_policies.traffic_filters.value.source.cidr, null)
              source_host = try(traffic_filter.value.source.host, local.defaults.meraki.networks.networks_appliance_sdwan_internet_policies.traffic_filters.value.source.host, null)
              source_port = try(traffic_filter.value.source.port, local.defaults.meraki.networks.networks_appliance_sdwan_internet_policies.traffic_filters.value.source.port, null)
              source_vlan = try(traffic_filter.value.source.vlan, local.defaults.meraki.networks.networks_appliance_sdwan_internet_policies.traffic_filters.value.source.vlan, null)
            }]
          }]
        } if try(network.appliance.sdwan_internet_policies, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_sdwan_internet_policies" "net_networks_appliance_sdwan_internet_policies" {
  for_each   = { for i, v in local.networks_networks_appliance_sdwan_internet_policies : i => v }
  network_id = each.value.network_id

  wan_traffic_uplink_preferences = try(each.value.wan_traffic_uplink_preferences, null)

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

  depends_on = [meraki_network_device_claim.net_device_claim]
}

locals {
  appliance_per_ssid_settings_list = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for appliance_rf_profile in try(network.appliance.rf_profiles, []) : [
            for settings in try(appliance_rf_profile.per_ssid_settings, []) : {
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

  depends_on = [meraki_network_device_claim.net_device_claim]
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
