locals {
  networks_appliance_content_filtering = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                    = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id             = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
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
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}

locals {
  networks_appliance_firewall_firewalled_services = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for appliance_firewall_firewalled_service in try(network.appliance.firewall.firewalled_services, []) : {
            key         = format("%s/%s/%s/%s", domain.name, organization.name, network.name, appliance_firewall_firewalled_service.service_name)
            network_id  = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
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
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}

locals {
  networks_appliance_firewall_inbound_firewall_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          rules = try(network.appliance.firewall.inbound_firewall_rules.rules, null) == null ? null : [
            for rule in try(network.appliance.firewall.inbound_firewall_rules.rules, []) : {
              comment        = try(rule.comment, local.defaults.meraki.domains.organizations.networks.appliance.firewall.inbound_firewall_rules.rules.comment, null)
              policy         = try(rule.policy, local.defaults.meraki.domains.organizations.networks.appliance.firewall.inbound_firewall_rules.rules.policy, null)
              protocol       = try(rule.protocol, local.defaults.meraki.domains.organizations.networks.appliance.firewall.inbound_firewall_rules.rules.protocol, null)
              src_port       = try(rule.source_port, local.defaults.meraki.domains.organizations.networks.appliance.firewall.inbound_firewall_rules.rules.source_port, null)
              src_cidr       = try(rule.source_cidr, local.defaults.meraki.domains.organizations.networks.appliance.firewall.inbound_firewall_rules.rules.source_cidr, null)
              dest_port      = try(rule.destination_port, local.defaults.meraki.domains.organizations.networks.appliance.firewall.inbound_firewall_rules.rules.destination_port, null)
              dest_cidr      = try(rule.destination_cidr, local.defaults.meraki.domains.organizations.networks.appliance.firewall.inbound_firewall_rules.rules.destination_cidr, null)
              syslog_enabled = try(rule.syslog, local.defaults.meraki.domains.organizations.networks.appliance.firewall.inbound_firewall_rules.rules.syslog, null)
            }
          ]
          syslog_default_rule = try(network.appliance.firewall.inbound_firewall_rules.syslog_default_rule, local.defaults.meraki.domains.organizations.networks.appliance.firewall.inbound_firewall_rules.syslog_default_rule, null)
        } if try(network.appliance.firewall.inbound_firewall_rules, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_inbound_firewall_rules" "networks_appliance_firewall_inbound_firewall_rules" {
  for_each            = { for v in local.networks_appliance_firewall_inbound_firewall_rules : v.key => v }
  network_id          = each.value.network_id
  rules               = each.value.rules
  syslog_default_rule = each.value.syslog_default_rule
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
    meraki_appliance_vlan.networks_appliance_vlans,
  ]
}

locals {
  networks_appliance_firewall_l3_firewall_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          rules = [
            for rule in try(network.appliance.firewall.l3_firewall_rules.rules, []) : {
              comment        = try(rule.comment, local.defaults.meraki.domains.organizations.networks.appliance.firewall.l3_firewall_rules.rules.comment, null)
              policy         = try(rule.policy, local.defaults.meraki.domains.organizations.networks.appliance.firewall.l3_firewall_rules.rules.policy, null)
              protocol       = try(rule.protocol, local.defaults.meraki.domains.organizations.networks.appliance.firewall.l3_firewall_rules.rules.protocol, null)
              src_port       = try(rule.source_port, local.defaults.meraki.domains.organizations.networks.appliance.firewall.l3_firewall_rules.rules.source_port, null)
              src_cidr       = try(rule.source_cidr, local.defaults.meraki.domains.organizations.networks.appliance.firewall.l3_firewall_rules.rules.source_cidr, null)
              dest_port      = try(rule.destination_port, local.defaults.meraki.domains.organizations.networks.appliance.firewall.l3_firewall_rules.rules.destination_port, null)
              dest_cidr      = try(rule.destination_cidr, local.defaults.meraki.domains.organizations.networks.appliance.firewall.l3_firewall_rules.rules.destination_cidr, null)
              syslog_enabled = try(rule.syslog, local.defaults.meraki.domains.organizations.networks.appliance.firewall.l3_firewall_rules.rules.syslog, null)
            }
          ]
          syslog_default_rule = try(network.appliance.firewall.l3_firewall_rules.syslog_default_rule, local.defaults.meraki.domains.organizations.networks.appliance.firewall.l3_firewall_rules.syslog_default_rule, null)
        } if try(network.appliance.firewall.l3_firewall_rules, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_l3_firewall_rules" "networks_appliance_firewall_l3_firewall_rules" {
  for_each            = { for v in local.networks_appliance_firewall_l3_firewall_rules : v.key => v }
  network_id          = each.value.network_id
  rules               = each.value.rules
  syslog_default_rule = each.value.syslog_default_rule
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
    meraki_appliance_vlan.networks_appliance_vlans,
  ]
}

locals {
  networks_appliance_firewall_l7_firewall_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          rules = try(network.appliance.firewall.l7_firewall_rules, null) == null ? null : [
            for appliance_firewall_l7_firewall_rule in try(network.appliance.firewall.l7_firewall_rules, []) : {
              policy          = try(appliance_firewall_l7_firewall_rule.policy, local.defaults.meraki.domains.organizations.networks.appliance.firewall.l7_firewall_rules.policy, null)
              type            = try(appliance_firewall_l7_firewall_rule.type, local.defaults.meraki.domains.organizations.networks.appliance.firewall.l7_firewall_rules.type, null)
              value           = try(appliance_firewall_l7_firewall_rule.value, local.defaults.meraki.domains.organizations.networks.appliance.firewall.l7_firewall_rules.value, null)
              value_countries = try(appliance_firewall_l7_firewall_rule.value_countries, local.defaults.meraki.domains.organizations.networks.appliance.firewall.l7_firewall_rules.value_countries, null)
            }
          ]
        } if try(network.appliance.firewall.l7_firewall_rules, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_l7_firewall_rules" "networks_appliance_firewall_l7_firewall_rules" {
  for_each   = { for v in local.networks_appliance_firewall_l7_firewall_rules : v.key => v }
  network_id = each.value.network_id
  rules      = each.value.rules
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}

locals {
  networks_appliance_firewall_one_to_many_nat_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          rules = try(network.appliance.firewall.one_to_many_nat_rules, null) == null ? null : [
            for appliance_firewall_one_to_many_nat_rule in try(network.appliance.firewall.one_to_many_nat_rules, []) : {
              public_ip = try(appliance_firewall_one_to_many_nat_rule.public_ip, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_many_nat_rules.public_ip, null)
              uplink    = try(appliance_firewall_one_to_many_nat_rule.uplink, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_many_nat_rules.uplink, null)
              port_rules = try(appliance_firewall_one_to_many_nat_rule.port_rules, null) == null ? null : [
                for port_rule in try(appliance_firewall_one_to_many_nat_rule.port_rules, []) : {
                  name        = try(port_rule.name, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_many_nat_rules.port_rules.name, null)
                  protocol    = try(port_rule.protocol, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_many_nat_rules.port_rules.protocol, null)
                  public_port = try(port_rule.public_port, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_many_nat_rules.port_rules.public_port, null)
                  local_ip    = try(port_rule.local_ip, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_many_nat_rules.port_rules.local_ip, null)
                  local_port  = try(port_rule.local_port, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_many_nat_rules.port_rules.local_port, null)
                  allowed_ips = try(port_rule.allowed_ips, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_many_nat_rules.port_rules.allowed_ips, null)
                }
              ]
            }
          ]
        } if try(network.appliance.firewall.one_to_many_nat_rules, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_one_to_many_nat_rules" "networks_appliance_firewall_one_to_many_nat_rules" {
  for_each   = { for v in local.networks_appliance_firewall_one_to_many_nat_rules : v.key => v }
  network_id = each.value.network_id
  rules      = each.value.rules
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}

locals {
  networks_appliance_firewall_one_to_one_nat_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          rules = try(network.appliance.firewall.one_to_one_nat_rules, null) == null ? null : [
            for appliance_firewall_one_to_one_nat_rule in try(network.appliance.firewall.one_to_one_nat_rules, []) : {
              name      = try(appliance_firewall_one_to_one_nat_rule.name, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_one_nat_rules.name, null)
              public_ip = try(appliance_firewall_one_to_one_nat_rule.public_ip, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_one_nat_rules.public_ip, null)
              lan_ip    = try(appliance_firewall_one_to_one_nat_rule.lan_ip, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_one_nat_rules.lan_ip, null)
              uplink    = try(appliance_firewall_one_to_one_nat_rule.uplink, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_one_nat_rules.uplink, null)
              allowed_inbound = try(appliance_firewall_one_to_one_nat_rule.allowed_inbound, null) == null ? null : [
                for allowed_inbound in try(appliance_firewall_one_to_one_nat_rule.allowed_inbound, []) : {
                  protocol          = try(allowed_inbound.protocol, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_one_nat_rules.allowed_inbound.protocol, null)
                  destination_ports = try(allowed_inbound.destination_ports, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_one_nat_rules.allowed_inbound.destination_ports, null)
                  allowed_ips       = try(allowed_inbound.allowed_ips, local.defaults.meraki.domains.organizations.networks.appliance.firewall.one_to_one_nat_rules.allowed_inbound.allowed_ips, null)
                }
              ]
            }
          ]
        } if try(network.appliance.firewall.one_to_one_nat_rules, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_one_to_one_nat_rules" "networks_appliance_firewall_one_to_one_nat_rules" {
  for_each   = { for v in local.networks_appliance_firewall_one_to_one_nat_rules : v.key => v }
  network_id = each.value.network_id
  rules      = each.value.rules
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}

locals {
  networks_appliance_firewall_port_forwarding_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          rules = try(network.appliance.firewall.port_forwarding_rules, null) == null ? null : [
            for appliance_firewall_port_forwarding_rule in try(network.appliance.firewall.port_forwarding_rules, []) : {
              name        = try(appliance_firewall_port_forwarding_rule.name, local.defaults.meraki.domains.organizations.networks.appliance.firewall.port_forwarding_rules.name, null)
              lan_ip      = try(appliance_firewall_port_forwarding_rule.lan_ip, local.defaults.meraki.domains.organizations.networks.appliance.firewall.port_forwarding_rules.lan_ip, null)
              uplink      = try(appliance_firewall_port_forwarding_rule.uplink, local.defaults.meraki.domains.organizations.networks.appliance.firewall.port_forwarding_rules.uplink, null)
              public_port = try(appliance_firewall_port_forwarding_rule.public_port, local.defaults.meraki.domains.organizations.networks.appliance.firewall.port_forwarding_rules.public_port, null)
              local_port  = try(appliance_firewall_port_forwarding_rule.local_port, local.defaults.meraki.domains.organizations.networks.appliance.firewall.port_forwarding_rules.local_port, null)
              allowed_ips = try(appliance_firewall_port_forwarding_rule.allowed_ips, local.defaults.meraki.domains.organizations.networks.appliance.firewall.port_forwarding_rules.allowed_ips, null)
              protocol    = try(appliance_firewall_port_forwarding_rule.protocol, local.defaults.meraki.domains.organizations.networks.appliance.firewall.port_forwarding_rules.protocol, null)
            }
          ]
        } if try(network.appliance.firewall.port_forwarding_rules, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_port_forwarding_rules" "networks_appliance_firewall_port_forwarding_rules" {
  for_each   = { for v in local.networks_appliance_firewall_port_forwarding_rules : v.key => v }
  network_id = each.value.network_id
  rules      = each.value.rules
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}

locals {
  networks_appliance_firewall_settings_spoofing_protection_ip_source_guard_mode = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                                      = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id                               = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
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
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}

locals {
  networks_appliance_ports = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          organization_id = local.organization_ids[format("%s/%s", domain.name, organization.name)]
          key             = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id      = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          ports = [
            for appliance_port in try(network.appliance.ports, []) : {
              port_ids = flatten([for port_id_range in appliance_port.port_id_ranges : [
                for port_id in range(port_id_range.from, port_id_range.to + 1) : port_id
              ]])
              data = appliance_port
            }
          ]
        } if try(network.appliance.ports, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_ports" "networks_appliance_ports" {
  for_each        = { for v in local.networks_appliance_ports : v.key => v }
  organization_id = each.value.organization_id
  network_id      = each.value.network_id
  items = flatten([
    for ports in each.value.ports : [
      for port_id in ports.port_ids : {
        port_id               = port_id
        enabled               = try(ports.data.enabled, local.defaults.meraki.domains.organizations.networks.appliance_ports.enabled, null)
        drop_untagged_traffic = try(ports.data.drop_untagged_traffic, local.defaults.meraki.domains.organizations.networks.appliance_ports.drop_untagged_traffic, null)
        type                  = try(ports.data.type, local.defaults.meraki.domains.organizations.networks.appliance_ports.type, null)
        vlan                  = try(ports.data.vlan, local.defaults.meraki.domains.organizations.networks.appliance_ports.vlan, null)
        allowed_vlans         = try(ports.data.allowed_vlans, local.defaults.meraki.domains.organizations.networks.appliance_ports.allowed_vlans, null)
        access_policy         = try(ports.data.access_policy, local.defaults.meraki.domains.organizations.networks.appliance_ports.access_policy, null)
      }
    ]
  ])
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
    meraki_appliance_vlan.networks_appliance_vlans,
    meraki_appliance_single_lan.networks_appliance_single_lan,
  ]
}

locals {
  networks_appliance_security_intrusion = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                              = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id                       = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          mode                             = try(network.appliance.security_intrusion.mode, local.defaults.meraki.domains.organizations.networks.appliance.security_intrusion.mode, null)
          ids_rulesets                     = try(network.appliance.security_intrusion.ids_rulesets, local.defaults.meraki.domains.organizations.networks.appliance.security_intrusion.ids_rulesets, null)
          protected_networks_use_default   = try(network.appliance.security_intrusion.protected_networks.use_default, local.defaults.meraki.domains.organizations.networks.appliance.security_intrusion.protected_networks.use_default, null)
          protected_networks_included_cidr = try(network.appliance.security_intrusion.protected_networks.included_cidr, local.defaults.meraki.domains.organizations.networks.appliance.security_intrusion.protected_networks.included_cidr, null)
          protected_networks_excluded_cidr = try(network.appliance.security_intrusion.protected_networks.excluded_cidr, local.defaults.meraki.domains.organizations.networks.appliance.security_intrusion.protected_networks.excluded_cidr, null)
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
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}

locals {
  networks_appliance_security_malware = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          mode       = try(network.appliance.security_malware.mode, local.defaults.meraki.domains.organizations.networks.appliance.security_malware.mode, null)
          allowed_urls = try(network.appliance.security_malware.allowed_urls, null) == null ? null : [
            for allowed_url in try(network.appliance.security_malware.allowed_urls, []) : {
              url     = try(allowed_url.url, local.defaults.meraki.domains.organizations.networks.appliance.security_malware.allowed_urls.url, null)
              comment = try(allowed_url.comment, local.defaults.meraki.domains.organizations.networks.appliance.security_malware.allowed_urls.comment, null)
            }
          ]
          allowed_files = try(network.appliance.security_malware.allowed_files, null) == null ? null : [
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
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}

locals {
  networks_appliance_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                    = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id             = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
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
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}

locals {
  networks_appliance_single_lan = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key          = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id   = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          subnet       = try(network.appliance.single_lan.subnet, local.defaults.meraki.domains.organizations.networks.appliance.single_lan.subnet, null)
          appliance_ip = try(network.appliance.single_lan.appliance_ip, local.defaults.meraki.domains.organizations.networks.appliance.single_lan.appliance_ip, null)
          ipv6_enabled = try(network.appliance.single_lan.ipv6.enabled, local.defaults.meraki.domains.organizations.networks.appliance.single_lan.ipv6.enabled, null)
          ipv6_prefix_assignments = try(network.appliance.single_lan.ipv6.prefix_assignments, null) == null ? null : [
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
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}

locals {
  networks_appliance_vlans = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for appliance_vlan in try(network.appliance.vlans, []) : {
            key             = format("%s/%s/%s/%s", domain.name, organization.name, network.name, appliance_vlan.vlan_id)
            network_id      = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
            vlan_id         = try(appliance_vlan.vlan_id, local.defaults.meraki.domains.organizations.networks.appliance.vlans.vlan_id, null)
            appliance_ip    = try(appliance_vlan.appliance_ip, local.defaults.meraki.domains.organizations.networks.appliance.vlans.appliance_ip, null)
            group_policy_id = try(meraki_network_group_policy.networks_group_policies[format("%s/%s/%s/%s", domain.name, organization.name, network.name, appliance_vlan.group_policy_name)].id, null)
            ipv6_enabled    = try(appliance_vlan.ipv6.enabled, local.defaults.meraki.domains.organizations.networks.appliance.vlans.ipv6.enabled, null)
            ipv6_prefix_assignments = try(appliance_vlan.ipv6.prefix_assignments, null) == null ? null : [
              for ipv6_prefix_assignment in try(appliance_vlan.ipv6.prefix_assignments, []) : {
                autonomous           = try(ipv6_prefix_assignment.autonomous, local.defaults.meraki.domains.organizations.networks.appliance.vlans.ipv6.prefix_assignments.autonomous, null)
                disabled             = try(ipv6_prefix_assignment.disabled, local.defaults.meraki.domains.organizations.networks.appliance.vlans.ipv6.prefix_assignments.disabled, null)
                static_prefix        = try(ipv6_prefix_assignment.static_prefix, local.defaults.meraki.domains.organizations.networks.appliance.vlans.ipv6.prefix_assignments.static_prefix, null)
                static_appliance_ip6 = try(ipv6_prefix_assignment.static_appliance_ip6, local.defaults.meraki.domains.organizations.networks.appliance.vlans.ipv6.prefix_assignments.static_appliance_ip6, null)
                origin_type          = try(ipv6_prefix_assignment.origin.type, local.defaults.meraki.domains.organizations.networks.appliance.vlans.ipv6.prefix_assignments.origin.type, null)
                origin_interfaces    = try(ipv6_prefix_assignment.origin.interfaces, local.defaults.meraki.domains.organizations.networks.appliance.vlans.ipv6.prefix_assignments.origin.interfaces, null)
              }
            ]
            name   = try(appliance_vlan.name, local.defaults.meraki.domains.organizations.networks.appliance.vlans.name, null)
            subnet = try(appliance_vlan.subnet, local.defaults.meraki.domains.organizations.networks.appliance.vlans.subnet, null)
            dhcp = {
              vpn_nat_subnet            = try(appliance_vlan.vpn_nat_subnet, local.defaults.meraki.domains.organizations.networks.appliance.vlans.vpn_nat_subnet, null)
              dhcp_boot_options_enabled = try(appliance_vlan.dhcp_boot_options, local.defaults.meraki.domains.organizations.networks.appliance.vlans.dhcp_boot_options, null)
              dhcp_handling             = try(appliance_vlan.dhcp_handling, local.defaults.meraki.domains.organizations.networks.appliance.vlans.dhcp_handling, null)
              dhcp_lease_time           = try(appliance_vlan.dhcp_lease_time, local.defaults.meraki.domains.organizations.networks.appliance.vlans.dhcp_lease_time, null)
              dhcp_options = try(appliance_vlan.dhcp_options, null) == null ? null : [
                for dhcp_option in try(appliance_vlan.dhcp_options, []) : {
                  code  = try(dhcp_option.code, local.defaults.meraki.domains.organizations.networks.appliance.vlans.dhcp_options.code, null)
                  type  = try(dhcp_option.type, local.defaults.meraki.domains.organizations.networks.appliance.vlans.dhcp_options.type, null)
                  value = try(dhcp_option.value, local.defaults.meraki.domains.organizations.networks.appliance.vlans.dhcp_options.value, null)
                }
              ]
              dns_nameservers        = try(appliance_vlan.dns_nameservers, local.defaults.meraki.domains.organizations.networks.appliance.vlans.dns_nameservers, null)
              mandatory_dhcp_enabled = try(appliance_vlan.mandatory_dhcp, local.defaults.meraki.domains.organizations.networks.appliance.vlans.mandatory_dhcp, null)
              reserved_ip_ranges = try(appliance_vlan.reserved_ip_ranges, null) == null ? null : [
                for reserved_ip_range in try(appliance_vlan.reserved_ip_ranges, []) : {
                  start   = try(reserved_ip_range.start, local.defaults.meraki.domains.organizations.networks.appliance.vlans.reserved_ip_ranges.start, null)
                  end     = try(reserved_ip_range.end, local.defaults.meraki.domains.organizations.networks.appliance.vlans.reserved_ip_ranges.end, null)
                  comment = try(reserved_ip_range.comment, local.defaults.meraki.domains.organizations.networks.appliance.vlans.reserved_ip_ranges.comment, null)
                }
              ]
              fixed_ip_assignments = try(appliance_vlan.fixed_ip_assignments, null) == null ? null : {
                for fixed_ip_assignment in try(appliance_vlan.fixed_ip_assignments, []) :
                fixed_ip_assignment.mac => {
                  ip   = try(fixed_ip_assignment.ip, local.defaults.meraki.domains.organizations.networks.appliance.vlans.fixed_ip_assignments.ip, null)
                  name = try(fixed_ip_assignment.name, local.defaults.meraki.domains.organizations.networks.appliance.vlans.fixed_ip_assignments.name, null)
                }
              }
              dhcp_relay_server_ips = try(appliance_vlan.dhcp_relay_server_ips, local.defaults.meraki.domains.organizations.networks.appliance.vlans.dhcp_relay_server_ips, null)
              dhcp_boot_next_server = try(appliance_vlan.dhcp_boot_next_server, local.defaults.meraki.domains.organizations.networks.appliance.vlans.dhcp_boot_next_server, null)
              dhcp_boot_filename    = try(appliance_vlan.dhcp_boot_filename, local.defaults.meraki.domains.organizations.networks.appliance.vlans.dhcp_boot_filename, null)
            }
          }
        ]
      ]
    ]
  ])

  networks_appliance_vlans_dhcp_all = [
    for appliance_vlan in local.networks_appliance_vlans : {
      key        = appliance_vlan.key
      network_id = appliance_vlan.network_id
      vlan_id    = appliance_vlan.vlan_id
      data       = appliance_vlan.dhcp
      non_null_data = {
        for field, value in appliance_vlan.dhcp :
        field => value
        if value != null
      }
    }
  ]

  networks_appliance_vlans_dhcp = flatten([
    for appliance_vlan_dhcp in local.networks_appliance_vlans_dhcp_all :
    appliance_vlan_dhcp
    if length(appliance_vlan_dhcp.non_null_data) > 0
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
  depends_on = [
    meraki_appliance_vlans_settings.networks_appliance_vlans_settings,
  ]
}

resource "meraki_appliance_vlan_dhcp" "networks_appliance_vlans_dhcp" {
  for_each                  = { for v in local.networks_appliance_vlans_dhcp : v.key => v }
  network_id                = each.value.network_id
  vlan_id                   = each.value.vlan_id
  dhcp_boot_options_enabled = each.value.data.dhcp_boot_options_enabled
  dhcp_handling             = each.value.data.dhcp_handling
  dhcp_lease_time           = each.value.data.dhcp_lease_time
  dhcp_options              = each.value.data.dhcp_options
  dns_nameservers           = each.value.data.dns_nameservers
  mandatory_dhcp_enabled    = each.value.data.mandatory_dhcp_enabled
  reserved_ip_ranges        = each.value.data.reserved_ip_ranges
  dhcp_relay_server_ips     = each.value.data.dhcp_relay_server_ips
  dhcp_boot_filename        = each.value.data.dhcp_boot_filename
  dhcp_boot_next_server     = each.value.data.dhcp_boot_next_server
  vpn_nat_subnet            = each.value.data.vpn_nat_subnet
  fixed_ip_assignments      = each.value.data.fixed_ip_assignments
  depends_on = [
    meraki_appliance_vlan.networks_appliance_vlans,
  ]
}

locals {
  networks_appliance_vlans_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key           = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id    = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          vlans_enabled = try(length(network.appliance.vlans) > 0, false)
        } if try(network.appliance, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_vlans_settings" "networks_appliance_vlans_settings" {
  for_each      = { for v in local.networks_appliance_vlans_settings : v.key => v }
  network_id    = each.value.network_id
  vlans_enabled = each.value.vlans_enabled
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}

locals {
  networks_appliance_vpn_bgp = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key             = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id      = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          enabled         = try(network.appliance.vpn_bgp.enabled, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.enabled, null)
          as_number       = try(network.appliance.vpn_bgp.as_number, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.as_number, null)
          ibgp_hold_timer = try(network.appliance.vpn_bgp.ibgp_hold_timer, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.ibgp_hold_timer, null)
          neighbors = try(network.appliance.vpn_bgp.neighbors, null) == null ? null : [
            for neighbor in try(network.appliance.vpn_bgp.neighbors, []) : {
              ip                      = try(neighbor.ip, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.neighbors.ip, null)
              ipv6_address            = try(neighbor.ipv6, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.neighbors.ipv6, null)
              remote_as_number        = try(neighbor.remote_as_number, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.neighbors.remote_as_number, null)
              receive_limit           = try(neighbor.receive_limit, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.neighbors.receive_limit, null)
              allow_transit           = try(neighbor.allow_transit, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.neighbors.allow_transit, null)
              ebgp_hold_timer         = try(neighbor.ebgp_hold_timer, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.neighbors.ebgp_hold_timer, null)
              ebgp_multihop           = try(neighbor.ebgp_multihop, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.neighbors.ebgp_multihop, null)
              source_interface        = try(neighbor.source_interface, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.neighbors.source_interface, null)
              next_hop_ip             = try(neighbor.next_hop_ip, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.neighbors.next_hop_ip, null)
              ttl_security_enabled    = try(neighbor.ttl_security, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.neighbors.ttl_security, null)
              authentication_password = try(neighbor.password, local.defaults.meraki.domains.organizations.networks.appliance.vpn_bgp.neighbors.password, null)
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
  depends_on = [
    meraki_appliance_site_to_site_vpn.networks_appliance_vpn_site_to_site_vpn,
  ]
}

locals {
  networks_appliance_vpn_site_to_site_vpn = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          mode       = try(network.appliance.vpn_site_to_site_vpn.mode, local.defaults.meraki.domains.organizations.networks.appliance.vpn_site_to_site_vpn.mode, null)
          hubs = try(network.appliance.vpn_site_to_site_vpn.hubs, null) == null ? null : [
            for hub in try(network.appliance.vpn_site_to_site_vpn.hubs, []) : {
              hub_id            = local.network_ids[format("%s/%s/%s", domain.name, organization.name, hub.hub_network_name)]
              use_default_route = try(hub.use_default_route, local.defaults.meraki.domains.organizations.networks.appliance.vpn_site_to_site_vpn.hubs.use_default_route, null)
            }
          ]
          subnets = try(network.appliance.vpn_site_to_site_vpn.subnets, null) == null ? null : [
            for subnet in try(network.appliance.vpn_site_to_site_vpn.subnets, []) : {
              local_subnet      = try(subnet.local_subnet, local.defaults.meraki.domains.organizations.networks.appliance.vpn_site_to_site_vpn.subnets.local_subnet, null)
              use_vpn           = try(subnet.use_vpn, local.defaults.meraki.domains.organizations.networks.appliance.vpn_site_to_site_vpn.subnets.use_vpn, null)
              nat_enabled       = try(subnet.nat.enabled, local.defaults.meraki.domains.organizations.networks.appliance.vpn_site_to_site_vpn.subnets.nat.enabled, null)
              nat_remote_subnet = try(subnet.nat.remote_subnet, local.defaults.meraki.domains.organizations.networks.appliance.vpn_site_to_site_vpn.subnets.nat.remote_subnet, null)
            }
          ]
          subnet_nat_is_allowed = try(network.appliance.vpn_site_to_site_vpn.subnet_nat, local.defaults.meraki.domains.organizations.networks.appliance.vpn_site_to_site_vpn.subnet_nat, null)
        } if try(network.appliance.vpn_site_to_site_vpn, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_site_to_site_vpn" "networks_appliance_vpn_site_to_site_vpn" {
  for_each              = { for v in local.networks_appliance_vpn_site_to_site_vpn : v.key => v }
  network_id            = each.value.network_id
  mode                  = each.value.mode
  hubs                  = each.value.hubs
  subnets               = each.value.subnets
  subnet_nat_is_allowed = each.value.subnet_nat_is_allowed
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
    meraki_appliance_single_lan.networks_appliance_single_lan,
    meraki_appliance_vlan.networks_appliance_vlans,
  ]
}

locals {
  networks_appliance_warm_spare = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key          = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id   = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
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
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}

locals {
  networks_appliance_static_routes = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for appliance_static_route in try(network.appliance.static_routes, []) : {
            key             = format("%s/%s/%s/%s", domain.name, organization.name, network.name, appliance_static_route.name)
            network_id      = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
            name            = try(appliance_static_route.name, local.defaults.meraki.domains.organizations.networks.appliance.static_routes.name, null)
            subnet          = try(appliance_static_route.subnet, local.defaults.meraki.domains.organizations.networks.appliance.static_routes.subnet, null)
            gateway_ip      = try(appliance_static_route.gateway_ip, local.defaults.meraki.domains.organizations.networks.appliance.static_routes.gateway_ip, null)
            gateway_vlan_id = try(appliance_static_route.gateway_vlan_id, local.defaults.meraki.domains.organizations.networks.appliance.static_routes.gateway_vlan_id, null)
          }
        ]
      ]
    ]
  ])
}

resource "meraki_appliance_static_route" "networks_appliance_static_routes" {
  for_each        = { for v in local.networks_appliance_static_routes : v.key => v }
  network_id      = each.value.network_id
  name            = each.value.name
  subnet          = each.value.subnet
  gateway_ip      = each.value.gateway_ip
  gateway_vlan_id = each.value.gateway_vlan_id
  depends_on = [
    meraki_appliance_vlan.networks_appliance_vlans,
    meraki_appliance_single_lan.networks_appliance_single_lan,
  ]
}

locals {
  networks_appliance_sdwan_internet_policies = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          wan_traffic_uplink_preferences = [
            for appliance_sdwan_internet_policy in try(network.appliance.sdwan_internet_policies, []) : {
              preferred_uplink               = try(appliance_sdwan_internet_policy.preferred_uplink, local.defaults.meraki.domains.organizations.networks.appliance.sdwan_internet_policies.preferred_uplink, null)
              fail_over_criterion            = try(appliance_sdwan_internet_policy.fail_over_criterion, local.defaults.meraki.domains.organizations.networks.appliance.sdwan_internet_policies.fail_over_criterion, null)
              performance_class_type         = try(appliance_sdwan_internet_policy.performance_class.type, local.defaults.meraki.domains.organizations.networks.appliance.sdwan_internet_policies.performance_class.type, null)
              builtin_performance_class_name = try(appliance_sdwan_internet_policy.performance_class.builtin_performance_class_name, local.defaults.meraki.domains.organizations.networks.appliance.sdwan_internet_policies.performance_class.builtin_performance_class_name, null)
              custom_performance_class_id    = try(meraki_appliance_traffic_shaping_custom_performance_class.networks_appliance_traffic_shaping_custom_performance_classes[format("%s/%s/%s/%s", domain.name, organization.name, network.name, appliance_sdwan_internet_policy.performance_class.custom_performance_class_name)].id, null)
              traffic_filters = [
                for traffic_filter in try(appliance_sdwan_internet_policy.traffic_filters, []) : {
                  type             = try(traffic_filter.type, local.defaults.meraki.domains.organizations.networks.appliance.sdwan_internet_policies.traffic_filters.type, null)
                  protocol         = try(traffic_filter.value.protocol, local.defaults.meraki.domains.organizations.networks.appliance.sdwan_internet_policies.traffic_filters.value.protocol, null)
                  source_port      = try(traffic_filter.value.source.port, local.defaults.meraki.domains.organizations.networks.appliance.sdwan_internet_policies.traffic_filters.value.source.port, null)
                  source_cidr      = try(traffic_filter.value.source.cidr, local.defaults.meraki.domains.organizations.networks.appliance.sdwan_internet_policies.traffic_filters.value.source.cidr, null)
                  source_vlan      = try(traffic_filter.value.source.vlan, local.defaults.meraki.domains.organizations.networks.appliance.sdwan_internet_policies.traffic_filters.value.source.vlan, null)
                  source_host      = try(traffic_filter.value.source.host, local.defaults.meraki.domains.organizations.networks.appliance.sdwan_internet_policies.traffic_filters.value.source.host, null)
                  destination_port = try(traffic_filter.value.destination.port, local.defaults.meraki.domains.organizations.networks.appliance.sdwan_internet_policies.traffic_filters.value.destination.port, null)
                  destination_cidr = try(traffic_filter.value.destination.cidr, local.defaults.meraki.domains.organizations.networks.appliance.sdwan_internet_policies.traffic_filters.value.destination.cidr, null)
                  destination_applications = try(traffic_filter.value.destination.applications, null) == null ? null : [
                    for value_destination_application in try(traffic_filter.value.destination.applications, []) : {
                      id   = try(value_destination_application.id, local.defaults.meraki.domains.organizations.networks.appliance.sdwan_internet_policies.traffic_filters.value.destination.applications.id, null)
                      name = try(value_destination_application.name, local.defaults.meraki.domains.organizations.networks.appliance.sdwan_internet_policies.traffic_filters.value.destination.applications.name, null)
                      type = try(value_destination_application.type, local.defaults.meraki.domains.organizations.networks.appliance.sdwan_internet_policies.traffic_filters.value.destination.applications.type, null)
                    }
                  ]
                }
              ]
            }
          ]
        } if try(network.appliance.sdwan_internet_policies, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_sdwan_internet_policies" "networks_appliance_sdwan_internet_policies" {
  for_each                       = { for v in local.networks_appliance_sdwan_internet_policies : v.key => v }
  network_id                     = each.value.network_id
  wan_traffic_uplink_preferences = each.value.wan_traffic_uplink_preferences
  depends_on = [
    meraki_appliance_vlan.networks_appliance_vlans,
    meraki_appliance_single_lan.networks_appliance_single_lan,
  ]
}

locals {
  networks_appliance_traffic_shaping = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                         = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id                  = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          global_bandwidth_limit_up   = try(network.appliance.traffic_shaping.global_bandwidth_limits.limit_up, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.global_bandwidth_limits.limit_up, null)
          global_bandwidth_limit_down = try(network.appliance.traffic_shaping.global_bandwidth_limits.limit_down, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.global_bandwidth_limits.limit_down, null)
        } if try(network.appliance.traffic_shaping, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_traffic_shaping" "networks_appliance_traffic_shaping" {
  for_each                    = { for v in local.networks_appliance_traffic_shaping : v.key => v }
  network_id                  = each.value.network_id
  global_bandwidth_limit_up   = each.value.global_bandwidth_limit_up
  global_bandwidth_limit_down = each.value.global_bandwidth_limit_down
  depends_on = [
    meraki_appliance_vlan.networks_appliance_vlans,
    meraki_appliance_single_lan.networks_appliance_single_lan,
  ]
}

locals {
  networks_appliance_traffic_shaping_custom_performance_classes = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for appliance_traffic_shaping_custom_performance_class in try(network.appliance.traffic_shaping.custom_performance_classes, []) : {
            key                 = format("%s/%s/%s/%s", domain.name, organization.name, network.name, appliance_traffic_shaping_custom_performance_class.name)
            network_id          = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
            name                = try(appliance_traffic_shaping_custom_performance_class.name, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.custom_performance_classes.name, null)
            max_latency         = try(appliance_traffic_shaping_custom_performance_class.max_latency, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.custom_performance_classes.max_latency, null)
            max_jitter          = try(appliance_traffic_shaping_custom_performance_class.max_jitter, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.custom_performance_classes.max_jitter, null)
            max_loss_percentage = try(appliance_traffic_shaping_custom_performance_class.max_loss_percentage, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.custom_performance_classes.max_loss_percentage, null)
          }
        ]
      ]
    ]
  ])
}

resource "meraki_appliance_traffic_shaping_custom_performance_class" "networks_appliance_traffic_shaping_custom_performance_classes" {
  for_each            = { for v in local.networks_appliance_traffic_shaping_custom_performance_classes : v.key => v }
  network_id          = each.value.network_id
  name                = each.value.name
  max_latency         = each.value.max_latency
  max_jitter          = each.value.max_jitter
  max_loss_percentage = each.value.max_loss_percentage
  depends_on = [
    meraki_appliance_vlan.networks_appliance_vlans,
    meraki_appliance_single_lan.networks_appliance_single_lan,
  ]
}

locals {
  networks_appliance_traffic_shaping_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                   = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id            = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          default_rules_enabled = try(network.appliance.traffic_shaping.rules.default_rules, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.rules.default_rules, null)
          rules = try(network.appliance.traffic_shaping.rules.rules, null) == null ? null : [
            for rule in try(network.appliance.traffic_shaping.rules.rules, []) : {
              definitions = [
                for definition in try(rule.definitions, []) : {
                  type  = try(definition.type, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.rules.rules.definitions.type, null)
                  value = try(definition.value, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.rules.rules.definitions.value, null)
                }
              ]
              per_client_bandwidth_limit_settings = try(rule.per_client_bandwidth_limits.settings, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.rules.rules.per_client_bandwidth_limits.settings, null)
              per_client_bandwidth_limit_up       = try(rule.per_client_bandwidth_limits.bandwidth_limits.limit_up, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.rules.rules.per_client_bandwidth_limits.bandwidth_limits.limit_up, null)
              per_client_bandwidth_limit_down     = try(rule.per_client_bandwidth_limits.bandwidth_limits.limit_down, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.rules.rules.per_client_bandwidth_limits.bandwidth_limits.limit_down, null)
              dscp_tag_value                      = try(rule.dscp_tag_value, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.rules.rules.dscp_tag_value, null)
              priority                            = try(rule.priority, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.rules.rules.priority, null)
            }
          ]
        } if try(network.appliance.traffic_shaping.rules, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_traffic_shaping_rules" "networks_appliance_traffic_shaping_rules" {
  for_each              = { for v in local.networks_appliance_traffic_shaping_rules : v.key => v }
  network_id            = each.value.network_id
  default_rules_enabled = each.value.default_rules_enabled
  rules                 = each.value.rules
  depends_on = [
    meraki_appliance_vlan.networks_appliance_vlans,
    meraki_appliance_single_lan.networks_appliance_single_lan,
  ]
}

locals {
  networks_appliance_traffic_shaping_uplink_bandwidth_limits = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                 = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id          = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          wan1_limit_up       = try(network.appliance.traffic_shaping.uplink_bandwidth_limits.wan1.limit_up, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_bandwidth_limits.wan1.limit_up, null)
          wan1_limit_down     = try(network.appliance.traffic_shaping.uplink_bandwidth_limits.wan1.limit_down, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_bandwidth_limits.wan1.limit_down, null)
          wan2_limit_up       = try(network.appliance.traffic_shaping.uplink_bandwidth_limits.wan2.limit_up, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_bandwidth_limits.wan2.limit_up, null)
          wan2_limit_down     = try(network.appliance.traffic_shaping.uplink_bandwidth_limits.wan2.limit_down, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_bandwidth_limits.wan2.limit_down, null)
          cellular_limit_up   = try(network.appliance.traffic_shaping.uplink_bandwidth_limits.cellular.limit_up, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_bandwidth_limits.cellular.limit_up, null)
          cellular_limit_down = try(network.appliance.traffic_shaping.uplink_bandwidth_limits.cellular.limit_down, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_bandwidth_limits.cellular.limit_down, null)
        } if try(network.appliance.traffic_shaping.uplink_bandwidth_limits, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_traffic_shaping_uplink_bandwidth" "networks_appliance_traffic_shaping_uplink_bandwidth_limits" {
  for_each            = { for v in local.networks_appliance_traffic_shaping_uplink_bandwidth_limits : v.key => v }
  network_id          = each.value.network_id
  wan1_limit_up       = each.value.wan1_limit_up
  wan1_limit_down     = each.value.wan1_limit_down
  wan2_limit_up       = each.value.wan2_limit_up
  wan2_limit_down     = each.value.wan2_limit_down
  cellular_limit_up   = each.value.cellular_limit_up
  cellular_limit_down = each.value.cellular_limit_down
  depends_on = [
    meraki_appliance_vlan.networks_appliance_vlans,
    meraki_appliance_single_lan.networks_appliance_single_lan,
  ]
}

locals {
  networks_appliance_traffic_shaping_uplink_selection = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                                     = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id                              = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          active_active_auto_vpn_enabled          = try(network.appliance.traffic_shaping.uplink_selection.active_active_auto_vpn, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.active_active_auto_vpn, null)
          default_uplink                          = try(network.appliance.traffic_shaping.uplink_selection.default_uplink, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.default_uplink, null)
          load_balancing_enabled                  = try(network.appliance.traffic_shaping.uplink_selection.load_balancing, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.load_balancing, null)
          failover_and_failback_immediate_enabled = try(network.appliance.traffic_shaping.uplink_selection.failover_and_failback_immediate, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.failover_and_failback_immediate, null)

          wan_traffic_uplink_preferences = try(network.appliance.traffic_shaping.uplink_selection.wan_traffic_uplink_preferences, null) == null ? null : [
            for wan_traffic_uplink_preference in try(network.appliance.traffic_shaping.uplink_selection.wan_traffic_uplink_preferences, []) : {
              traffic_filters = [
                for traffic_filter in try(wan_traffic_uplink_preference.traffic_filters, []) : {
                  type             = try(traffic_filter.type, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.wan_traffic_uplink_preferences.traffic_filters.type, null)
                  protocol         = try(traffic_filter.value.protocol, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.wan_traffic_uplink_preferences.traffic_filters.value.protocol, null)
                  source_port      = try(traffic_filter.value.source.port, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.wan_traffic_uplink_preferences.traffic_filters.value.source.port, null)
                  source_cidr      = try(traffic_filter.value.source.cidr, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.wan_traffic_uplink_preferences.traffic_filters.value.source.cidr, null)
                  source_vlan      = try(traffic_filter.value.source.vlan, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.wan_traffic_uplink_preferences.traffic_filters.value.source.vlan, null)
                  source_host      = try(traffic_filter.value.source.host, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.wan_traffic_uplink_preferences.traffic_filters.value.source.host, null)
                  destination_port = try(traffic_filter.value.destination.port, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.wan_traffic_uplink_preferences.traffic_filters.value.destination.port, null)
                  destination_cidr = try(traffic_filter.value.destination.cidr, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.wan_traffic_uplink_preferences.traffic_filters.value.destination.cidr, null)
                }
              ]
              preferred_uplink = try(wan_traffic_uplink_preference.preferred_uplink, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.wan_traffic_uplink_preferences.preferred_uplink, null)
            }
          ]

          vpn_traffic_uplink_preferences = try(network.appliance.traffic_shaping.uplink_selection.vpn_traffic_uplink_preferences, null) == null ? null : [
            for vpn_traffic_uplink_preference in try(network.appliance.traffic_shaping.uplink_selection.vpn_traffic_uplink_preferences, []) : {
              traffic_filters = [
                for traffic_filter in try(vpn_traffic_uplink_preference.traffic_filters, []) : {
                  type                = try(traffic_filter.type, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.vpn_traffic_uplink_preferences.traffic_filters.type, null)
                  id                  = try(traffic_filter.value.id, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.vpn_traffic_uplink_preferences.traffic_filters.value.id, null)
                  protocol            = try(traffic_filter.value.protocol, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.vpn_traffic_uplink_preferences.traffic_filters.value.protocol, null)
                  source_port         = try(traffic_filter.value.source.port, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.vpn_traffic_uplink_preferences.traffic_filters.value.source.port, null)
                  source_cidr         = try(traffic_filter.value.source.cidr, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.vpn_traffic_uplink_preferences.traffic_filters.value.source.cidr, null)
                  source_network      = try(traffic_filter.value.source.network, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.vpn_traffic_uplink_preferences.traffic_filters.value.source.network, null)
                  source_vlan         = try(traffic_filter.value.source.vlan, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.vpn_traffic_uplink_preferences.traffic_filters.value.source.vlan, null)
                  source_host         = try(traffic_filter.value.source.host, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.vpn_traffic_uplink_preferences.traffic_filters.value.source.host, null)
                  destination_port    = try(traffic_filter.value.destination.port, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.vpn_traffic_uplink_preferences.traffic_filters.value.destination.port, null)
                  destination_cidr    = try(traffic_filter.value.destination.cidr, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.vpn_traffic_uplink_preferences.traffic_filters.value.destination.cidr, null)
                  destination_network = try(traffic_filter.value.destination.network, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.vpn_traffic_uplink_preferences.traffic_filters.value.destination.network, null)
                  destination_vlan    = try(traffic_filter.value.destination.vlan, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.vpn_traffic_uplink_preferences.traffic_filters.value.destination.vlan, null)
                  destination_host    = try(traffic_filter.value.destination.host, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.vpn_traffic_uplink_preferences.traffic_filters.value.destination.host, null)
                  destination_fqdn    = try(traffic_filter.value.destination.fqdn, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.vpn_traffic_uplink_preferences.traffic_filters.value.destination.fqdn, null)
                }
              ]
              preferred_uplink               = try(vpn_traffic_uplink_preference.preferred_uplink, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.vpn_traffic_uplink_preferences.preferred_uplink, null)
              fail_over_criterion            = try(vpn_traffic_uplink_preference.fail_over_criterion, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.vpn_traffic_uplink_preferences.fail_over_criterion, null)
              performance_class_type         = try(vpn_traffic_uplink_preference.performance_class.type, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.vpn_traffic_uplink_preferences.performance_class.type, null)
              builtin_performance_class_name = try(vpn_traffic_uplink_preference.performance_class.builtin_performance_class_name, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.uplink_selection.vpn_traffic_uplink_preferences.performance_class.builtin_performance_class_name, null)
              custom_performance_class_id    = try(meraki_appliance_traffic_shaping_custom_performance_class.networks_appliance_traffic_shaping_custom_performance_classes[format("%s/%s/%s/%s", domain.name, organization.name, network.name, vpn_traffic_uplink_preference.performance_class.custom_performance_class_name)].id, null)
            }
          ]
        } if try(network.appliance.traffic_shaping.uplink_selection, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_traffic_shaping_uplink_selection" "networks_appliance_traffic_shaping_uplink_selection" {
  for_each                                = { for v in local.networks_appliance_traffic_shaping_uplink_selection : v.key => v }
  network_id                              = each.value.network_id
  active_active_auto_vpn_enabled          = each.value.active_active_auto_vpn_enabled
  default_uplink                          = each.value.default_uplink
  load_balancing_enabled                  = each.value.load_balancing_enabled
  failover_and_failback_immediate_enabled = each.value.failover_and_failback_immediate_enabled
  wan_traffic_uplink_preferences          = each.value.wan_traffic_uplink_preferences
  vpn_traffic_uplink_preferences          = each.value.vpn_traffic_uplink_preferences
  depends_on = [
    meraki_appliance_vlan.networks_appliance_vlans,
    meraki_appliance_single_lan.networks_appliance_single_lan,
  ]
}

locals {
  networks_appliance_traffic_shaping_vpn_exclusions = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          custom = try(network.appliance.traffic_shaping.vpn_exclusions.custom, null) == null ? null : [
            for custom in try(network.appliance.traffic_shaping.vpn_exclusions.custom, []) : {
              protocol    = try(custom.protocol, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.vpn_exclusions.custom.protocol, null)
              destination = try(custom.destination, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.vpn_exclusions.custom.destination, null)
              port        = try(custom.port, local.defaults.meraki.domains.organizations.networks.appliance.traffic_shaping.vpn_exclusions.custom.port, null)
            }
          ]
          major_applications = try(network.appliance.traffic_shaping.vpn_exclusions.major_applications, null) == null ? null : [
            for major_application in try(network.appliance.traffic_shaping.vpn_exclusions.major_applications, []) : {
              id = major_application
            }
          ]
        } if try(network.appliance.traffic_shaping.vpn_exclusions, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_traffic_shaping_vpn_exclusions" "networks_appliance_traffic_shaping_vpn_exclusions" {
  for_each           = { for v in local.networks_appliance_traffic_shaping_vpn_exclusions : v.key => v }
  network_id         = each.value.network_id
  custom             = each.value.custom
  major_applications = each.value.major_applications
  depends_on = [
    meraki_appliance_vlan.networks_appliance_vlans,
    meraki_appliance_single_lan.networks_appliance_single_lan,
  ]
}

locals {
  networks_appliance_ssids = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for appliance_ssid in try(network.appliance.ssids, []) : {
            key             = format("%s/%s/%s/%s", domain.name, organization.name, network.name, appliance_ssid.name)
            network_id      = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
            number          = try(appliance_ssid.number, local.defaults.meraki.domains.organizations.networks.appliance.ssids.number, null)
            name            = try(appliance_ssid.name, local.defaults.meraki.domains.organizations.networks.appliance.ssids.name, null)
            enabled         = try(appliance_ssid.enabled, local.defaults.meraki.domains.organizations.networks.appliance.ssids.enabled, null)
            default_vlan_id = try(appliance_ssid.default_vlan_id, local.defaults.meraki.domains.organizations.networks.appliance.ssids.default_vlan_id, null)
            auth_mode       = try(appliance_ssid.auth_mode, local.defaults.meraki.domains.organizations.networks.appliance.ssids.auth_mode, null)
            psk             = try(appliance_ssid.psk, local.defaults.meraki.domains.organizations.networks.appliance.ssids.psk, null)
            radius_servers = try(appliance_ssid.radius_servers, null) == null ? null : [
              for radius_server in try(appliance_ssid.radius_servers, []) : {
                host   = try(radius_server.host, local.defaults.meraki.domains.organizations.networks.appliance.ssids.radius_servers.host, null)
                port   = try(radius_server.port, local.defaults.meraki.domains.organizations.networks.appliance.ssids.radius_servers.port, null)
                secret = try(radius_server.secret, local.defaults.meraki.domains.organizations.networks.appliance.ssids.radius_servers.secret, null)
              }
            ]
            encryption_mode                        = try(appliance_ssid.encryption_mode, local.defaults.meraki.domains.organizations.networks.appliance.ssids.encryption_mode, null)
            wpa_encryption_mode                    = try(appliance_ssid.wpa_encryption_mode, local.defaults.meraki.domains.organizations.networks.appliance.ssids.wpa_encryption_mode, null)
            visible                                = try(appliance_ssid.visible, local.defaults.meraki.domains.organizations.networks.appliance.ssids.visible, null)
            dhcp_enforced_deauthentication_enabled = try(appliance_ssid.dhcp_enforced_deauthentication, local.defaults.meraki.domains.organizations.networks.appliance.ssids.dhcp_enforced_deauthentication, null)
            dot11w_enabled                         = try(appliance_ssid.dot11w.enabled, local.defaults.meraki.domains.organizations.networks.appliance.ssids.dot11w.enabled, null)
            dot11w_required                        = try(appliance_ssid.dot11w.required, local.defaults.meraki.domains.organizations.networks.appliance.ssids.dot11w.required, null)
          }
        ]
      ]
    ]
  ])
}

resource "meraki_appliance_ssid" "networks_appliance_ssids" {
  for_each                               = { for v in local.networks_appliance_ssids : v.key => v }
  network_id                             = each.value.network_id
  number                                 = each.value.number
  name                                   = each.value.name
  enabled                                = each.value.enabled
  default_vlan_id                        = each.value.default_vlan_id
  auth_mode                              = each.value.auth_mode
  psk                                    = each.value.psk
  radius_servers                         = each.value.radius_servers
  encryption_mode                        = each.value.encryption_mode
  wpa_encryption_mode                    = each.value.wpa_encryption_mode
  visible                                = each.value.visible
  dhcp_enforced_deauthentication_enabled = each.value.dhcp_enforced_deauthentication_enabled
  dot11w_enabled                         = each.value.dot11w_enabled
  dot11w_required                        = each.value.dot11w_required
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}

locals {
  networks_appliance_rf_profiles_per_ssid_settings_list = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for appliance_rf_profile in try(network.appliance.rf_profiles, []) : [
            for per_ssid_setting in try(appliance_rf_profile.per_ssid_settings, []) : {
              key = format(
                "%s/%s/%s/%s/%s",
                domain.name,
                organization.name,
                network.name,
                appliance_rf_profile.name,
                meraki_appliance_ssid.networks_appliance_ssids[format("%s/%s/%s/%s", domain.name, organization.name, network.name, per_ssid_setting.ssid_name)].number,
              )
              band_operation_mode   = try(per_ssid_setting.band_operation_mode, local.defaults.meraki.domains.organizations.networks.appliance.rf_profiles.per_ssid_settings.band_operation_mode, null)
              band_steering_enabled = try(per_ssid_setting.band_steering, local.defaults.meraki.domains.organizations.networks.appliance.rf_profiles.per_ssid_settings.band_steering, null)
            }
          ]
        ]
      ]
    ]
  ])
  networks_appliance_rf_profiles_per_ssid_settings = { for s in local.networks_appliance_rf_profiles_per_ssid_settings_list : s.key => s }
  networks_appliance_rf_profiles = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for appliance_rf_profile in try(network.appliance.rf_profiles, []) : {
            key                               = format("%s/%s/%s/%s", domain.name, organization.name, network.name, appliance_rf_profile.name)
            network_id                        = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
            per_ssid_settings                 = [for i in range(4) : try(local.networks_appliance_rf_profiles_per_ssid_settings[format("%s/%s/%s/%s/%s", domain.name, organization.name, network.name, appliance_rf_profile.name, i)], null)]
            name                              = try(appliance_rf_profile.name, local.defaults.meraki.domains.organizations.networks.appliance.rf_profiles.name, null)
            two_four_ghz_settings_min_bitrate = try(appliance_rf_profile.two_four_ghz_settings.min_bitrate, local.defaults.meraki.domains.organizations.networks.appliance.rf_profiles.two_four_ghz_settings.min_bitrate, null)
            two_four_ghz_settings_ax_enabled  = try(appliance_rf_profile.two_four_ghz_settings.ax, local.defaults.meraki.domains.organizations.networks.appliance.rf_profiles.two_four_ghz_settings.ax, null)
            five_ghz_settings_min_bitrate     = try(appliance_rf_profile.five_ghz_settings.min_bitrate, local.defaults.meraki.domains.organizations.networks.appliance.rf_profiles.five_ghz_settings.min_bitrate, null)
            five_ghz_settings_ax_enabled      = try(appliance_rf_profile.five_ghz_settings.ax, local.defaults.meraki.domains.organizations.networks.appliance.rf_profiles.five_ghz_settings.ax, null)
          }
        ]
      ]
    ]
  ])
}

resource "meraki_appliance_rf_profile" "networks_appliance_rf_profiles" {
  for_each                                  = { for v in local.networks_appliance_rf_profiles : v.key => v }
  network_id                                = each.value.network_id
  name                                      = each.value.name
  two_four_ghz_settings_min_bitrate         = each.value.two_four_ghz_settings_min_bitrate
  two_four_ghz_settings_ax_enabled          = each.value.two_four_ghz_settings_ax_enabled
  five_ghz_settings_min_bitrate             = each.value.five_ghz_settings_min_bitrate
  five_ghz_settings_ax_enabled              = each.value.five_ghz_settings_ax_enabled
  per_ssid_settings_1_band_operation_mode   = try(each.value.per_ssid_settings[0].band_operation_mode, null)
  per_ssid_settings_1_band_steering_enabled = try(each.value.per_ssid_settings[0].band_steering_enabled, null)
  per_ssid_settings_2_band_operation_mode   = try(each.value.per_ssid_settings[1].band_operation_mode, null)
  per_ssid_settings_2_band_steering_enabled = try(each.value.per_ssid_settings[1].band_steering_enabled, null)
  per_ssid_settings_3_band_operation_mode   = try(each.value.per_ssid_settings[2].band_operation_mode, null)
  per_ssid_settings_3_band_steering_enabled = try(each.value.per_ssid_settings[2].band_steering_enabled, null)
  per_ssid_settings_4_band_operation_mode   = try(each.value.per_ssid_settings[3].band_operation_mode, null)
  per_ssid_settings_4_band_steering_enabled = try(each.value.per_ssid_settings[3].band_steering_enabled, null)
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}

locals {
  devices_appliance_radio_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for device in try(network.devices, []) : {
            key                                = format("%s/%s/%s/%s", domain.name, organization.name, network.name, device.name)
            serial                             = meraki_device.devices[format("%s/%s/%s/%s", domain.name, organization.name, network.name, device.name)].serial
            rf_profile_id                      = try(meraki_appliance_rf_profile.networks_appliance_rf_profiles[format("%s/%s/%s/%s", domain.name, organization.name, network.name, device.appliance.radio_settings.rf_profile_name)].id, null)
            two_four_ghz_settings_channel      = try(device.appliance.radio_settings.two_four_ghz_settings.channel, local.defaults.meraki.domains.organizations.networks.devices.appliance.radio_settings.two_four_ghz_settings.channel, null)
            two_four_ghz_settings_target_power = try(device.appliance.radio_settings.two_four_ghz_settings.target_power, local.defaults.meraki.domains.organizations.networks.devices.appliance.radio_settings.two_four_ghz_settings.target_power, null)
            five_ghz_settings_channel          = try(device.appliance.radio_settings.five_ghz_settings.channel, local.defaults.meraki.domains.organizations.networks.devices.appliance.radio_settings.five_ghz_settings.channel, null)
            five_ghz_settings_channel_width    = try(device.appliance.radio_settings.five_ghz_settings.channel_width, local.defaults.meraki.domains.organizations.networks.devices.appliance.radio_settings.five_ghz_settings.channel_width, null)
            five_ghz_settings_target_power     = try(device.appliance.radio_settings.five_ghz_settings.target_power, local.defaults.meraki.domains.organizations.networks.devices.appliance.radio_settings.five_ghz_settings.target_power, null)
          } if try(device.appliance.radio_settings, null) != null
        ]
      ]
    ]
  ])
}

resource "meraki_appliance_radio_settings" "devices_appliance_radio_settings" {
  for_each                           = { for v in local.devices_appliance_radio_settings : v.key => v }
  serial                             = each.value.serial
  rf_profile_id                      = each.value.rf_profile_id
  two_four_ghz_settings_channel      = each.value.two_four_ghz_settings_channel
  two_four_ghz_settings_target_power = each.value.two_four_ghz_settings_target_power
  five_ghz_settings_channel          = each.value.five_ghz_settings_channel
  five_ghz_settings_channel_width    = each.value.five_ghz_settings_channel_width
  five_ghz_settings_target_power     = each.value.five_ghz_settings_target_power
}

locals {
  networks_appliance_connectivity_monitoring_destinations = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          destinations = [
            for appliance_connectivity_monitoring_destination in try(network.appliance.connectivity_monitoring_destinations, []) : {
              ip          = try(appliance_connectivity_monitoring_destination.ip, local.defaults.meraki.domains.organizations.networks.appliance.connectivity_monitoring_destinations.ip, null)
              description = try(appliance_connectivity_monitoring_destination.description, local.defaults.meraki.domains.organizations.networks.appliance.connectivity_monitoring_destinations.description, null)
              default     = try(appliance_connectivity_monitoring_destination.default, local.defaults.meraki.domains.organizations.networks.appliance.connectivity_monitoring_destinations.default, null)
            }
          ]
        } if try(network.appliance.connectivity_monitoring_destinations, null) != null
      ]
    ]
  ])
}

resource "meraki_appliance_connectivity_monitoring_destinations" "networks_appliance_connectivity_monitoring_destinations" {
  for_each     = { for v in local.networks_appliance_connectivity_monitoring_destinations : v.key => v }
  network_id   = each.value.network_id
  destinations = each.value.destinations
}
