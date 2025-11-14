locals {
  networks_switch_access_control_lists_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          rules = [
            for switch_access_control_lists_rule in try(network.switch.access_control_lists_rules, []) : {
              comment    = try(switch_access_control_lists_rule.comment, local.defaults.meraki.domains.organizations.networks.switch.access_control_lists_rules.comment, null)
              policy     = try(switch_access_control_lists_rule.policy, local.defaults.meraki.domains.organizations.networks.switch.access_control_lists_rules.policy, null)
              ip_version = try(switch_access_control_lists_rule.ip_version, local.defaults.meraki.domains.organizations.networks.switch.access_control_lists_rules.ip_version, null)
              protocol   = try(switch_access_control_lists_rule.protocol, local.defaults.meraki.domains.organizations.networks.switch.access_control_lists_rules.protocol, null)
              src_cidr   = try(switch_access_control_lists_rule.source_cidr, local.defaults.meraki.domains.organizations.networks.switch.access_control_lists_rules.source_cidr, null)
              src_port   = try(switch_access_control_lists_rule.source_port, local.defaults.meraki.domains.organizations.networks.switch.access_control_lists_rules.source_port, null)
              dst_cidr   = try(switch_access_control_lists_rule.destination_cidr, local.defaults.meraki.domains.organizations.networks.switch.access_control_lists_rules.destination_cidr, null)
              dst_port   = try(switch_access_control_lists_rule.destination_port, local.defaults.meraki.domains.organizations.networks.switch.access_control_lists_rules.destination_port, null)
              vlan       = try(switch_access_control_lists_rule.vlan, local.defaults.meraki.domains.organizations.networks.switch.access_control_lists_rules.vlan, null)
            }
          ]
        } if try(network.switch.access_control_lists_rules, null) != null
      ]
    ]
  ])
}

resource "meraki_switch_access_control_lists" "networks_switch_access_control_lists_rules" {
  for_each   = { for v in local.networks_switch_access_control_lists_rules : v.key => v }
  network_id = each.value.network_id
  rules      = each.value.rules
}

locals {
  networks_switch_access_policies = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for switch_access_policy in try(network.switch.access_policies, []) : {
            key        = format("%s/%s/%s/%s", domain.name, organization.name, network.name, switch_access_policy.name)
            network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
            name       = try(switch_access_policy.name, local.defaults.meraki.domains.organizations.networks.switch.access_policies.name, null)
            radius_servers = [
              for radius_server in try(switch_access_policy.radius_servers, []) : {
                # TODO Map from organization_radius_server_name.
                organization_radius_server_id = try(radius_server.organization_radius_server_id, local.defaults.meraki.domains.organizations.networks.switch.access_policies.radius_servers.organization_radius_server_id, null)
                host                          = try(radius_server.host, local.defaults.meraki.domains.organizations.networks.switch.access_policies.radius_servers.host, null)
                port                          = try(radius_server.port, local.defaults.meraki.domains.organizations.networks.switch.access_policies.radius_servers.port, null)
                secret                        = try(radius_server.secret, local.defaults.meraki.domains.organizations.networks.switch.access_policies.radius_servers.secret, null)
              }
            ]
            radius_critical_auth_data_vlan_id        = try(switch_access_policy.radius.critical_auth.data_vlan_id, local.defaults.meraki.domains.organizations.networks.switch.access_policies.radius.critical_auth.data_vlan_id, null)
            radius_critical_auth_voice_vlan_id       = try(switch_access_policy.radius.critical_auth.voice_vlan_id, local.defaults.meraki.domains.organizations.networks.switch.access_policies.radius.critical_auth.voice_vlan_id, null)
            radius_critical_auth_suspend_port_bounce = try(switch_access_policy.radius.critical_auth.suspend_port_bounce, local.defaults.meraki.domains.organizations.networks.switch.access_policies.radius.critical_auth.suspend_port_bounce, null)
            radius_failed_auth_vlan_id               = try(switch_access_policy.radius.failed_auth_vlan_id, local.defaults.meraki.domains.organizations.networks.switch.access_policies.radius.failed_auth_vlan_id, null)
            radius_re_authentication_interval        = try(switch_access_policy.radius.re_authentication_interval, local.defaults.meraki.domains.organizations.networks.switch.access_policies.radius.re_authentication_interval, null)
            radius_cache_enabled                     = try(switch_access_policy.radius.cache.enabled, local.defaults.meraki.domains.organizations.networks.switch.access_policies.radius.cache.enabled, null)
            radius_cache_timeout                     = try(switch_access_policy.radius.cache.timeout, local.defaults.meraki.domains.organizations.networks.switch.access_policies.radius.cache.timeout, null)
            guest_port_bouncing                      = try(switch_access_policy.guest_port_bouncing, local.defaults.meraki.domains.organizations.networks.switch.access_policies.guest_port_bouncing, null)
            radius_testing_enabled                   = try(switch_access_policy.radius_testing, local.defaults.meraki.domains.organizations.networks.switch.access_policies.radius_testing, null)
            radius_coa_support_enabled               = try(switch_access_policy.radius_coa_support, local.defaults.meraki.domains.organizations.networks.switch.access_policies.radius_coa_support, null)
            radius_accounting_enabled                = try(switch_access_policy.radius_accounting, local.defaults.meraki.domains.organizations.networks.switch.access_policies.radius_accounting, null)
            radius_accounting_servers = try(switch_access_policy.radius_accounting_servers, null) == null ? null : [
              for radius_accounting_server in try(switch_access_policy.radius_accounting_servers, []) : {
                # TODO Map from organization_radius_server_name.
                organization_radius_server_id = try(radius_accounting_server.organization_radius_server_id, local.defaults.meraki.domains.organizations.networks.switch.access_policies.radius_accounting_servers.organization_radius_server_id, null)
                host                          = try(radius_accounting_server.host, local.defaults.meraki.domains.organizations.networks.switch.access_policies.radius_accounting_servers.host, null)
                port                          = try(radius_accounting_server.port, local.defaults.meraki.domains.organizations.networks.switch.access_policies.radius_accounting_servers.port, null)
                secret                        = try(radius_accounting_server.secret, local.defaults.meraki.domains.organizations.networks.switch.access_policies.radius_accounting_servers.secret, null)
              }
            ]
            radius_group_attribute             = try(switch_access_policy.radius_group_attribute, local.defaults.meraki.domains.organizations.networks.switch.access_policies.radius_group_attribute, null)
            host_mode                          = try(switch_access_policy.host_mode, local.defaults.meraki.domains.organizations.networks.switch.access_policies.host_mode, null)
            access_policy_type                 = try(switch_access_policy.access_policy_type, local.defaults.meraki.domains.organizations.networks.switch.access_policies.access_policy_type, null)
            increase_access_speed              = try(switch_access_policy.increase_access_speed, local.defaults.meraki.domains.organizations.networks.switch.access_policies.increase_access_speed, null)
            guest_vlan_id                      = try(switch_access_policy.guest_vlan_id, local.defaults.meraki.domains.organizations.networks.switch.access_policies.guest_vlan_id, null)
            dot1x_control_direction            = try(switch_access_policy.dot1x_control_direction, local.defaults.meraki.domains.organizations.networks.switch.access_policies.dot1x_control_direction, null)
            voice_vlan_clients                 = try(switch_access_policy.voice_vlan_clients, local.defaults.meraki.domains.organizations.networks.switch.access_policies.voice_vlan_clients, null)
            url_redirect_walled_garden_enabled = try(switch_access_policy.url_redirect_walled_garden, local.defaults.meraki.domains.organizations.networks.switch.access_policies.url_redirect_walled_garden, null)
            url_redirect_walled_garden_ranges  = try(switch_access_policy.url_redirect_walled_garden_ranges, local.defaults.meraki.domains.organizations.networks.switch.access_policies.url_redirect_walled_garden_ranges, null)
          }
        ]
      ]
    ]
  ])
}

resource "meraki_switch_access_policy" "networks_switch_access_policies" {
  for_each                                 = { for v in local.networks_switch_access_policies : v.key => v }
  network_id                               = each.value.network_id
  name                                     = each.value.name
  radius_servers                           = each.value.radius_servers
  radius_critical_auth_data_vlan_id        = each.value.radius_critical_auth_data_vlan_id
  radius_critical_auth_voice_vlan_id       = each.value.radius_critical_auth_voice_vlan_id
  radius_critical_auth_suspend_port_bounce = each.value.radius_critical_auth_suspend_port_bounce
  radius_failed_auth_vlan_id               = each.value.radius_failed_auth_vlan_id
  radius_re_authentication_interval        = each.value.radius_re_authentication_interval
  radius_cache_enabled                     = each.value.radius_cache_enabled
  radius_cache_timeout                     = each.value.radius_cache_timeout
  guest_port_bouncing                      = each.value.guest_port_bouncing
  radius_testing_enabled                   = each.value.radius_testing_enabled
  radius_coa_support_enabled               = each.value.radius_coa_support_enabled
  radius_accounting_enabled                = each.value.radius_accounting_enabled
  radius_accounting_servers                = each.value.radius_accounting_servers
  radius_group_attribute                   = each.value.radius_group_attribute
  host_mode                                = each.value.host_mode
  access_policy_type                       = each.value.access_policy_type
  increase_access_speed                    = each.value.increase_access_speed
  guest_vlan_id                            = each.value.guest_vlan_id
  dot1x_control_direction                  = each.value.dot1x_control_direction
  voice_vlan_clients                       = each.value.voice_vlan_clients
  url_redirect_walled_garden_enabled       = each.value.url_redirect_walled_garden_enabled
  url_redirect_walled_garden_ranges        = each.value.url_redirect_walled_garden_ranges
}

locals {
  networks_switch_alternate_management_interface = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          enabled    = try(network.switch.alternate_management_interface.enabled, local.defaults.meraki.domains.organizations.networks.switch.alternate_management_interface.enabled, null)
          vlan_id    = try(network.switch.alternate_management_interface.vlan_id, local.defaults.meraki.domains.organizations.networks.switch.alternate_management_interface.vlan_id, null)
          protocols  = try(network.switch.alternate_management_interface.protocols, local.defaults.meraki.domains.organizations.networks.switch.alternate_management_interface.protocols, null)
          switches = try(network.switch.alternate_management_interface.switches, null) == null ? null : [
            for switch in try(network.switch.alternate_management_interface.switches, []) : {
              serial                  = meraki_device.devices[format("%s/%s/%s/%s", domain.name, organization.name, network.name, switch.device)].serial
              alternate_management_ip = try(switch.alternate_management_ip, local.defaults.meraki.domains.organizations.networks.switch.alternate_management_interface.switches.alternate_management_ip, null)
              subnet_mask             = try(switch.subnet_mask, local.defaults.meraki.domains.organizations.networks.switch.alternate_management_interface.switches.subnet_mask, null)
              gateway                 = try(switch.gateway, local.defaults.meraki.domains.organizations.networks.switch.alternate_management_interface.switches.gateway, null)
            }
          ]
        } if try(network.switch.alternate_management_interface, null) != null
      ]
    ]
  ])
}

resource "meraki_switch_alternate_management_interface" "networks_switch_alternate_management_interface" {
  for_each   = { for v in local.networks_switch_alternate_management_interface : v.key => v }
  network_id = each.value.network_id
  enabled    = each.value.enabled
  vlan_id    = each.value.vlan_id
  protocols  = each.value.protocols
  switches   = each.value.switches
}

locals {
  networks_switch_dhcp_server_policy = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                    = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id             = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          alerts_email_enabled   = try(network.switch.dhcp_server_policy.alerts_email, local.defaults.meraki.domains.organizations.networks.switch.dhcp_server_policy.alerts_email, null)
          default_policy         = try(network.switch.dhcp_server_policy.default_policy, local.defaults.meraki.domains.organizations.networks.switch.dhcp_server_policy.default_policy, null)
          allowed_servers        = try(network.switch.dhcp_server_policy.allowed_servers, local.defaults.meraki.domains.organizations.networks.switch.dhcp_server_policy.allowed_servers, null)
          blocked_servers        = try(network.switch.dhcp_server_policy.blocked_servers, local.defaults.meraki.domains.organizations.networks.switch.dhcp_server_policy.blocked_servers, null)
          arp_inspection_enabled = try(network.switch.dhcp_server_policy.arp_inspection, local.defaults.meraki.domains.organizations.networks.switch.dhcp_server_policy.arp_inspection, null)
        } if try(network.switch.dhcp_server_policy, null) != null
      ]
    ]
  ])
}

resource "meraki_switch_dhcp_server_policy" "networks_switch_dhcp_server_policy" {
  for_each               = { for v in local.networks_switch_dhcp_server_policy : v.key => v }
  network_id             = each.value.network_id
  alerts_email_enabled   = each.value.alerts_email_enabled
  default_policy         = each.value.default_policy
  allowed_servers        = each.value.allowed_servers
  blocked_servers        = each.value.blocked_servers
  arp_inspection_enabled = each.value.arp_inspection_enabled
}

locals {
  networks_switch_dhcp_server_policy_arp_inspection_trusted_servers = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for switch_dhcp_server_policy_arp_inspection_trusted_server in try(network.switch.dhcp_server_policy.arp_inspection_trusted_servers, []) : {
            key          = format("%s/%s/%s/%s", domain.name, organization.name, network.name, switch_dhcp_server_policy_arp_inspection_trusted_server.trusted_server_name)
            network_id   = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
            mac          = try(switch_dhcp_server_policy_arp_inspection_trusted_server.mac, local.defaults.meraki.domains.organizations.networks.switch.dhcp_server_policy.arp_inspection_trusted_servers.mac, null)
            vlan         = try(switch_dhcp_server_policy_arp_inspection_trusted_server.vlan, local.defaults.meraki.domains.organizations.networks.switch.dhcp_server_policy.arp_inspection_trusted_servers.vlan, null)
            ipv4_address = try(switch_dhcp_server_policy_arp_inspection_trusted_server.ipv4_address, local.defaults.meraki.domains.organizations.networks.switch.dhcp_server_policy.arp_inspection_trusted_servers.ipv4_address, null)
          }
        ]
      ]
    ]
  ])
}

resource "meraki_switch_dhcp_server_policy_arp_inspection_trusted_server" "networks_switch_dhcp_server_policy_arp_inspection_trusted_servers" {
  for_each     = { for v in local.networks_switch_dhcp_server_policy_arp_inspection_trusted_servers : v.key => v }
  network_id   = each.value.network_id
  mac          = each.value.mac
  vlan         = each.value.vlan
  ipv4_address = each.value.ipv4_address
}

locals {
  networks_switch_dscp_to_cos_mappings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          mappings = [
            for switch_dscp_to_cos_mapping in try(network.switch.dscp_to_cos_mappings, []) : {
              dscp  = try(switch_dscp_to_cos_mapping.dscp, local.defaults.meraki.domains.organizations.networks.switch.dscp_to_cos_mappings.dscp, null)
              cos   = try(switch_dscp_to_cos_mapping.cos, local.defaults.meraki.domains.organizations.networks.switch.dscp_to_cos_mappings.cos, null)
              title = try(switch_dscp_to_cos_mapping.title, local.defaults.meraki.domains.organizations.networks.switch.dscp_to_cos_mappings.title, null)
            }
          ]
        } if try(network.switch.dscp_to_cos_mappings, null) != null
      ]
    ]
  ])
}

resource "meraki_switch_dscp_to_cos_mappings" "networks_switch_dscp_to_cos_mappings" {
  for_each   = { for v in local.networks_switch_dscp_to_cos_mappings : v.key => v }
  network_id = each.value.network_id
  mappings   = each.value.mappings
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}


locals {
  networks_switch_link_aggregations = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for switch_link_aggregation in try(network.switch.link_aggregations, []) : {
            key        = format("%s/%s/%s/%s", domain.name, organization.name, network.name, switch_link_aggregation.link_aggregation_name)
            network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
            switch_ports = try(switch_link_aggregation.switch_ports, null) == null ? null : [
              for switch_port in try(switch_link_aggregation.switch_ports, []) : {
                serial  = meraki_device.devices[format("%s/%s/%s/%s", domain.name, organization.name, network.name, switch_port.device)].serial
                port_id = try(switch_port.port_id, local.defaults.meraki.domains.organizations.networks.switch.link_aggregations.switch_ports.port_id, null)
              }
            ]
            switch_profile_ports = try(switch_link_aggregation.switch_profile_ports, null) == null ? null : [
              for switch_profile_port in try(switch_link_aggregation.switch_profile_ports, []) : {
                profile = try(switch_profile_port.profile, local.defaults.meraki.domains.organizations.networks.switch.link_aggregations.switch_profile_ports.profile, null)
                port_id = try(switch_profile_port.port_id, local.defaults.meraki.domains.organizations.networks.switch.link_aggregations.switch_profile_ports.port_id, null)
              }
            ]
          }
        ]
      ]
    ]
  ])
}

resource "meraki_switch_link_aggregation" "networks_switch_link_aggregations" {
  for_each             = { for v in local.networks_switch_link_aggregations : v.key => v }
  network_id           = each.value.network_id
  switch_ports         = each.value.switch_ports
  switch_profile_ports = each.value.switch_profile_ports
  depends_on = [
    meraki_switch_stack.networks_switch_stacks,
  ]
}

locals {
  networks_switch_mtu = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key              = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id       = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          default_mtu_size = try(network.switch.mtu.default_mtu_size, local.defaults.meraki.domains.organizations.networks.switch.mtu.default_mtu_size, null)
          overrides = try(network.switch.mtu.overrides, null) == null ? null : [
            for override in try(network.switch.mtu.overrides, []) : {
              # TODO Map from device names to serials?
              switches        = try(override.switches, local.defaults.meraki.domains.organizations.networks.switch.mtu.overrides.switches, null)
              switch_profiles = try(override.switch_profiles, local.defaults.meraki.domains.organizations.networks.switch.mtu.overrides.switch_profiles, null)
              mtu_size        = try(override.mtu_size, local.defaults.meraki.domains.organizations.networks.switch.mtu.overrides.mtu_size, null)
            }
          ]
        } if try(network.switch.mtu, null) != null
      ]
    ]
  ])
}

resource "meraki_switch_mtu" "networks_switch_mtu" {
  for_each         = { for v in local.networks_switch_mtu : v.key => v }
  network_id       = each.value.network_id
  default_mtu_size = each.value.default_mtu_size
  overrides        = each.value.overrides
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}

locals {
  networks_switch_port_schedules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for switch_port_schedule in try(network.switch.port_schedules, []) : {
            key                            = format("%s/%s/%s/%s", domain.name, organization.name, network.name, switch_port_schedule.name)
            network_id                     = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
            name                           = try(switch_port_schedule.name, local.defaults.meraki.domains.organizations.networks.switch.port_schedules.name, null)
            port_schedule_monday_active    = try(switch_port_schedule.port_schedule.monday.active, local.defaults.meraki.domains.organizations.networks.switch.port_schedules.port_schedule.monday.active, null)
            port_schedule_monday_from      = try(switch_port_schedule.port_schedule.monday.from, local.defaults.meraki.domains.organizations.networks.switch.port_schedules.port_schedule.monday.from, null)
            port_schedule_monday_to        = try(switch_port_schedule.port_schedule.monday.to, local.defaults.meraki.domains.organizations.networks.switch.port_schedules.port_schedule.monday.to, null)
            port_schedule_tuesday_active   = try(switch_port_schedule.port_schedule.tuesday.active, local.defaults.meraki.domains.organizations.networks.switch.port_schedules.port_schedule.tuesday.active, null)
            port_schedule_tuesday_from     = try(switch_port_schedule.port_schedule.tuesday.from, local.defaults.meraki.domains.organizations.networks.switch.port_schedules.port_schedule.tuesday.from, null)
            port_schedule_tuesday_to       = try(switch_port_schedule.port_schedule.tuesday.to, local.defaults.meraki.domains.organizations.networks.switch.port_schedules.port_schedule.tuesday.to, null)
            port_schedule_wednesday_active = try(switch_port_schedule.port_schedule.wednesday.active, local.defaults.meraki.domains.organizations.networks.switch.port_schedules.port_schedule.wednesday.active, null)
            port_schedule_wednesday_from   = try(switch_port_schedule.port_schedule.wednesday.from, local.defaults.meraki.domains.organizations.networks.switch.port_schedules.port_schedule.wednesday.from, null)
            port_schedule_wednesday_to     = try(switch_port_schedule.port_schedule.wednesday.to, local.defaults.meraki.domains.organizations.networks.switch.port_schedules.port_schedule.wednesday.to, null)
            port_schedule_thursday_active  = try(switch_port_schedule.port_schedule.thursday.active, local.defaults.meraki.domains.organizations.networks.switch.port_schedules.port_schedule.thursday.active, null)
            port_schedule_thursday_from    = try(switch_port_schedule.port_schedule.thursday.from, local.defaults.meraki.domains.organizations.networks.switch.port_schedules.port_schedule.thursday.from, null)
            port_schedule_thursday_to      = try(switch_port_schedule.port_schedule.thursday.to, local.defaults.meraki.domains.organizations.networks.switch.port_schedules.port_schedule.thursday.to, null)
            port_schedule_friday_active    = try(switch_port_schedule.port_schedule.friday.active, local.defaults.meraki.domains.organizations.networks.switch.port_schedules.port_schedule.friday.active, null)
            port_schedule_friday_from      = try(switch_port_schedule.port_schedule.friday.from, local.defaults.meraki.domains.organizations.networks.switch.port_schedules.port_schedule.friday.from, null)
            port_schedule_friday_to        = try(switch_port_schedule.port_schedule.friday.to, local.defaults.meraki.domains.organizations.networks.switch.port_schedules.port_schedule.friday.to, null)
            port_schedule_saturday_active  = try(switch_port_schedule.port_schedule.saturday.active, local.defaults.meraki.domains.organizations.networks.switch.port_schedules.port_schedule.saturday.active, null)
            port_schedule_saturday_from    = try(switch_port_schedule.port_schedule.saturday.from, local.defaults.meraki.domains.organizations.networks.switch.port_schedules.port_schedule.saturday.from, null)
            port_schedule_saturday_to      = try(switch_port_schedule.port_schedule.saturday.to, local.defaults.meraki.domains.organizations.networks.switch.port_schedules.port_schedule.saturday.to, null)
            port_schedule_sunday_active    = try(switch_port_schedule.port_schedule.sunday.active, local.defaults.meraki.domains.organizations.networks.switch.port_schedules.port_schedule.sunday.active, null)
            port_schedule_sunday_from      = try(switch_port_schedule.port_schedule.sunday.from, local.defaults.meraki.domains.organizations.networks.switch.port_schedules.port_schedule.sunday.from, null)
            port_schedule_sunday_to        = try(switch_port_schedule.port_schedule.sunday.to, local.defaults.meraki.domains.organizations.networks.switch.port_schedules.port_schedule.sunday.to, null)
          }
        ]
      ]
    ]
  ])
}

resource "meraki_switch_port_schedule" "networks_switch_port_schedules" {
  for_each                       = { for v in local.networks_switch_port_schedules : v.key => v }
  network_id                     = each.value.network_id
  name                           = each.value.name
  port_schedule_monday_active    = each.value.port_schedule_monday_active
  port_schedule_monday_from      = each.value.port_schedule_monday_from
  port_schedule_monday_to        = each.value.port_schedule_monday_to
  port_schedule_tuesday_active   = each.value.port_schedule_tuesday_active
  port_schedule_tuesday_from     = each.value.port_schedule_tuesday_from
  port_schedule_tuesday_to       = each.value.port_schedule_tuesday_to
  port_schedule_wednesday_active = each.value.port_schedule_wednesday_active
  port_schedule_wednesday_from   = each.value.port_schedule_wednesday_from
  port_schedule_wednesday_to     = each.value.port_schedule_wednesday_to
  port_schedule_thursday_active  = each.value.port_schedule_thursday_active
  port_schedule_thursday_from    = each.value.port_schedule_thursday_from
  port_schedule_thursday_to      = each.value.port_schedule_thursday_to
  port_schedule_friday_active    = each.value.port_schedule_friday_active
  port_schedule_friday_from      = each.value.port_schedule_friday_from
  port_schedule_friday_to        = each.value.port_schedule_friday_to
  port_schedule_saturday_active  = each.value.port_schedule_saturday_active
  port_schedule_saturday_from    = each.value.port_schedule_saturday_from
  port_schedule_saturday_to      = each.value.port_schedule_saturday_to
  port_schedule_sunday_active    = each.value.port_schedule_sunday_active
  port_schedule_sunday_from      = each.value.port_schedule_sunday_from
  port_schedule_sunday_to        = each.value.port_schedule_sunday_to
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}


locals {
  networks_switch_qos_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for switch_qos_rule in try(network.switch.qos_rules, []) : {
            key            = format("%s/%s/%s/%s", domain.name, organization.name, network.name, switch_qos_rule.qos_rule_name)
            network_id     = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
            vlan           = try(switch_qos_rule.vlan, local.defaults.meraki.domains.organizations.networks.switch.qos_rules.vlan, null)
            protocol       = try(switch_qos_rule.protocol, local.defaults.meraki.domains.organizations.networks.switch.qos_rules.protocol, null)
            src_port       = try(switch_qos_rule.source_port, local.defaults.meraki.domains.organizations.networks.switch.qos_rules.source_port, null)
            src_port_range = try(switch_qos_rule.source_port_range, local.defaults.meraki.domains.organizations.networks.switch.qos_rules.source_port_range, null)
            dst_port       = try(switch_qos_rule.destination_port, local.defaults.meraki.domains.organizations.networks.switch.qos_rules.destination_port, null)
            dst_port_range = try(switch_qos_rule.destination_port_range, local.defaults.meraki.domains.organizations.networks.switch.qos_rules.destination_port_range, null)
            dscp           = try(switch_qos_rule.dscp, local.defaults.meraki.domains.organizations.networks.switch.qos_rules.dscp, null)
          }
        ]
      ]
    ]
  ])
}

resource "meraki_switch_qos_rule" "networks_switch_qos_rules" {
  for_each       = { for v in local.networks_switch_qos_rules : v.key => v }
  network_id     = each.value.network_id
  vlan           = each.value.vlan
  protocol       = each.value.protocol
  src_port       = each.value.src_port
  src_port_range = each.value.src_port_range
  dst_port       = each.value.dst_port
  dst_port_range = each.value.dst_port_range
  dscp           = each.value.dscp
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}

locals {
  networks_switch_qos_rules_order = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          rule_ids   = [for r in network.switch.qos_rules : meraki_switch_qos_rule.networks_switch_qos_rules[format("%s/%s/%s/%s", domain.name, organization.name, network.name, r.qos_rule_name)].id]
        } if try(network.switch.qos_rules, null) != null
      ]
    ]
  ])
}

resource "meraki_switch_qos_rule_order" "networks_switch_qos_rules_order" {
  for_each   = { for v in local.networks_switch_qos_rules_order : v.key => v }
  network_id = each.value.network_id
  rule_ids   = each.value.rule_ids
}

locals {
  networks_switch_routing_multicast = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                                                      = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id                                               = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          default_settings_igmp_snooping_enabled                   = try(network.switch.routing_multicast.default_settings.igmp_snooping, local.defaults.meraki.domains.organizations.networks.switch.routing_multicast.default_settings.igmp_snooping, null)
          default_settings_flood_unknown_multicast_traffic_enabled = try(network.switch.routing_multicast.default_settings.flood_unknown_multicast_traffic, local.defaults.meraki.domains.organizations.networks.switch.routing_multicast.default_settings.flood_unknown_multicast_traffic, null)
          overrides = try(network.switch.routing_multicast.overrides, null) == null ? null : [
            for override in try(network.switch.routing_multicast.overrides, []) : {
              switch_profiles = try(override.switch_profiles, local.defaults.meraki.domains.organizations.networks.switch.routing_multicast.overrides.switch_profiles, null)
              # TODO Map from device names to serials?
              switches = try(override.switches, local.defaults.meraki.domains.organizations.networks.switch.routing_multicast.overrides.switches, null)
              # TODO Map from stack names to IDs?
              stacks                                  = try(override.stacks, local.defaults.meraki.domains.organizations.networks.switch.routing_multicast.overrides.stacks, null)
              igmp_snooping_enabled                   = try(override.igmp_snooping, local.defaults.meraki.domains.organizations.networks.switch.routing_multicast.overrides.igmp_snooping, null)
              flood_unknown_multicast_traffic_enabled = try(override.flood_unknown_multicast_traffic, local.defaults.meraki.domains.organizations.networks.switch.routing_multicast.overrides.flood_unknown_multicast_traffic, null)
            }
          ]
        } if try(network.switch.routing_multicast, null) != null
      ]
    ]
  ])
}

resource "meraki_switch_routing_multicast" "networks_switch_routing_multicast" {
  for_each                                                 = { for v in local.networks_switch_routing_multicast : v.key => v }
  network_id                                               = each.value.network_id
  default_settings_igmp_snooping_enabled                   = each.value.default_settings_igmp_snooping_enabled
  default_settings_flood_unknown_multicast_traffic_enabled = each.value.default_settings_flood_unknown_multicast_traffic_enabled
  overrides                                                = each.value.overrides
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}

locals {
  networks_switch_routing_multicast_rendezvous_points = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for switch_routing_multicast_rendezvous_point in try(network.switch.routing_multicast_rendezvous_points, []) : {
            key             = format("%s/%s/%s/%s", domain.name, organization.name, network.name, switch_routing_multicast_rendezvous_point.rendezvous_point_name)
            network_id      = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
            interface_ip    = try(switch_routing_multicast_rendezvous_point.interface_ip, local.defaults.meraki.domains.organizations.networks.switch.routing_multicast_rendezvous_points.interface_ip, null)
            multicast_group = try(switch_routing_multicast_rendezvous_point.multicast_group, local.defaults.meraki.domains.organizations.networks.switch.routing_multicast_rendezvous_points.multicast_group, null)
          }
        ]
      ]
    ]
  ])
}

resource "meraki_switch_routing_multicast_rendezvous_point" "networks_switch_routing_multicast_rendezvous_points" {
  for_each        = { for v in local.networks_switch_routing_multicast_rendezvous_points : v.key => v }
  network_id      = each.value.network_id
  interface_ip    = each.value.interface_ip
  multicast_group = each.value.multicast_group
  depends_on = [
    meraki_switch_stack_routing_interface.networks_switch_stacks_routing_interfaces_not_first,
  ]
}

locals {
  networks_switch_routing_ospf = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                    = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id             = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          enabled                = try(network.switch.routing_ospf.enabled, local.defaults.meraki.domains.organizations.networks.switch.routing_ospf.enabled, null)
          hello_timer_in_seconds = try(network.switch.routing_ospf.hello_timer_in_seconds, local.defaults.meraki.domains.organizations.networks.switch.routing_ospf.hello_timer_in_seconds, null)
          dead_timer_in_seconds  = try(network.switch.routing_ospf.dead_timer_in_seconds, local.defaults.meraki.domains.organizations.networks.switch.routing_ospf.dead_timer_in_seconds, null)
          areas = try(network.switch.routing_ospf.areas, null) == null ? null : [
            for area in try(network.switch.routing_ospf.areas, []) : {
              area_id   = try(area.area_id, local.defaults.meraki.domains.organizations.networks.switch.routing_ospf.areas.area_id, null)
              area_name = try(area.area_name, local.defaults.meraki.domains.organizations.networks.switch.routing_ospf.areas.area_name, null)
              area_type = try(area.area_type, local.defaults.meraki.domains.organizations.networks.switch.routing_ospf.areas.area_type, null)
            }
          ]
          v3_enabled                = try(network.switch.routing_ospf.v3.enabled, local.defaults.meraki.domains.organizations.networks.switch.routing_ospf.v3.enabled, null)
          v3_hello_timer_in_seconds = try(network.switch.routing_ospf.v3.hello_timer_in_seconds, local.defaults.meraki.domains.organizations.networks.switch.routing_ospf.v3.hello_timer_in_seconds, null)
          v3_dead_timer_in_seconds  = try(network.switch.routing_ospf.v3.dead_timer_in_seconds, local.defaults.meraki.domains.organizations.networks.switch.routing_ospf.v3.dead_timer_in_seconds, null)
          v3_areas = try(network.switch.routing_ospf.v3.areas, null) == null ? null : [
            for v3_area in try(network.switch.routing_ospf.v3.areas, []) : {
              area_id   = try(v3_area.area_id, local.defaults.meraki.domains.organizations.networks.switch.routing_ospf.v3.areas.area_id, null)
              area_name = try(v3_area.area_name, local.defaults.meraki.domains.organizations.networks.switch.routing_ospf.v3.areas.area_name, null)
              area_type = try(v3_area.area_type, local.defaults.meraki.domains.organizations.networks.switch.routing_ospf.v3.areas.area_type, null)
            }
          ]
          md5_authentication_enabled        = try(network.switch.routing_ospf.md5_authentication, local.defaults.meraki.domains.organizations.networks.switch.routing_ospf.md5_authentication, null)
          md5_authentication_key_id         = try(network.switch.routing_ospf.md5_authentication_key.id, local.defaults.meraki.domains.organizations.networks.switch.routing_ospf.md5_authentication_key.id, null)
          md5_authentication_key_passphrase = try(network.switch.routing_ospf.md5_authentication_key.passphrase, local.defaults.meraki.domains.organizations.networks.switch.routing_ospf.md5_authentication_key.passphrase, null)
        } if try(network.switch.routing_ospf, null) != null
      ]
    ]
  ])
}

resource "meraki_switch_routing_ospf" "networks_switch_routing_ospf" {
  for_each                          = { for v in local.networks_switch_routing_ospf : v.key => v }
  network_id                        = each.value.network_id
  enabled                           = each.value.enabled
  hello_timer_in_seconds            = each.value.hello_timer_in_seconds
  dead_timer_in_seconds             = each.value.dead_timer_in_seconds
  areas                             = each.value.areas
  v3_enabled                        = each.value.v3_enabled
  v3_hello_timer_in_seconds         = each.value.v3_hello_timer_in_seconds
  v3_dead_timer_in_seconds          = each.value.v3_dead_timer_in_seconds
  v3_areas                          = each.value.v3_areas
  md5_authentication_enabled        = each.value.md5_authentication_enabled
  md5_authentication_key_id         = each.value.md5_authentication_key_id
  md5_authentication_key_passphrase = each.value.md5_authentication_key_passphrase
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}

locals {
  networks_switch_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id         = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          vlan               = try(network.switch.settings.vlan, local.defaults.meraki.domains.organizations.networks.switch.settings.vlan, null)
          use_combined_power = try(network.switch.settings.use_combined_power, local.defaults.meraki.domains.organizations.networks.switch.settings.use_combined_power, null)
          power_exceptions = try(network.switch.settings.power_exceptions, null) == null ? null : [
            for power_exception in try(network.switch.settings.power_exceptions, []) : {
              serial     = meraki_device.devices[format("%s/%s/%s/%s", domain.name, organization.name, network.name, power_exception.device)].serial
              power_type = try(power_exception.power_type, local.defaults.meraki.domains.organizations.networks.switch.settings.power_exceptions.power_type, null)
            }
          ]
          uplink_client_sampling_enabled = try(network.switch.settings.uplink_client_sampling, local.defaults.meraki.domains.organizations.networks.switch.settings.uplink_client_sampling, null)
          mac_blocklist_enabled          = try(network.switch.settings.mac_blocklist, local.defaults.meraki.domains.organizations.networks.switch.settings.mac_blocklist, null)
        } if try(network.switch.settings, null) != null
      ]
    ]
  ])
}

resource "meraki_switch_settings" "networks_switch_settings" {
  for_each                       = { for v in local.networks_switch_settings : v.key => v }
  network_id                     = each.value.network_id
  vlan                           = each.value.vlan
  use_combined_power             = each.value.use_combined_power
  power_exceptions               = each.value.power_exceptions
  uplink_client_sampling_enabled = each.value.uplink_client_sampling_enabled
  mac_blocklist_enabled          = each.value.mac_blocklist_enabled
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}

locals {
  networks_switch_storm_control = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                                        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id                                 = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          broadcast_threshold                        = try(network.switch.storm_control.broadcast_threshold, local.defaults.meraki.domains.organizations.networks.switch.storm_control.broadcast_threshold, null)
          multicast_threshold                        = try(network.switch.storm_control.multicast_threshold, local.defaults.meraki.domains.organizations.networks.switch.storm_control.multicast_threshold, null)
          unknown_unicast_threshold                  = try(network.switch.storm_control.unknown_unicast_threshold, local.defaults.meraki.domains.organizations.networks.switch.storm_control.unknown_unicast_threshold, null)
          treat_these_traffic_types_as_one_threshold = try(network.switch.storm_control.treat_these_traffic_types_as_one_threshold, local.defaults.meraki.domains.organizations.networks.switch.storm_control.treat_these_traffic_types_as_one_threshold, null)
        } if try(network.switch.storm_control, null) != null
      ]
    ]
  ])
}

resource "meraki_switch_storm_control" "networks_switch_storm_control" {
  for_each                                   = { for v in local.networks_switch_storm_control : v.key => v }
  network_id                                 = each.value.network_id
  broadcast_threshold                        = each.value.broadcast_threshold
  multicast_threshold                        = each.value.multicast_threshold
  unknown_unicast_threshold                  = each.value.unknown_unicast_threshold
  treat_these_traffic_types_as_one_threshold = each.value.treat_these_traffic_types_as_one_threshold
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}

locals {
  networks_switch_stp = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key          = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id   = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          rstp_enabled = try(network.switch.stp.rstp, local.defaults.meraki.domains.organizations.networks.switch.stp.rstp, null)
          stp_bridge_priority = try(network.switch.stp.stp_bridge_priority, null) == null ? null : [
            for stp_bridge_priority in try(network.switch.stp.stp_bridge_priority, []) : {
              switch_profiles = try(stp_bridge_priority.switch_profiles, local.defaults.meraki.domains.organizations.networks.switch.stp.stp_bridge_priority.switch_profiles, null)
              switches = try(stp_bridge_priority.switches, null) == null ? null : [
                for switch in try(stp_bridge_priority.switches, []) :
                meraki_device.devices[format("%s/%s/%s/%s", domain.name, organization.name, network.name, switch)].serial
              ]
              stacks = try(stp_bridge_priority.stacks, null) == null ? null : [
                for stack in try(stp_bridge_priority.stacks, []) :
                meraki_switch_stack.networks_switch_stacks[format("%s/%s/%s/%s", domain.name, organization.name, network.name, stack)].id
              ]
              stp_priority = try(stp_bridge_priority.stp_priority, local.defaults.meraki.domains.organizations.networks.switch.stp.stp_bridge_priority.stp_priority, null)
            }
          ]
        } if try(network.switch.stp, null) != null
      ]
    ]
  ])
}

resource "meraki_switch_stp" "networks_switch_stp" {
  for_each            = { for v in local.networks_switch_stp : v.key => v }
  network_id          = each.value.network_id
  rstp_enabled        = each.value.rstp_enabled
  stp_bridge_priority = each.value.stp_bridge_priority
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}

locals {
  networks_switch_stacks = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for switch_stack in try(network.switch_stacks, []) : {
            key        = format("%s/%s/%s/%s", domain.name, organization.name, network.name, switch_stack.name)
            network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
            name       = try(switch_stack.name, local.defaults.meraki.domains.organizations.networks.switch_stacks.name, null)
            serials    = [for device in switch_stack.devices : meraki_device.devices[format("%s/%s/%s/%s", domain.name, organization.name, network.name, device)].serial]
          }
        ]
      ]
    ]
  ])
}

resource "meraki_switch_stack" "networks_switch_stacks" {
  for_each   = { for v in local.networks_switch_stacks : v.key => v }
  network_id = each.value.network_id
  name       = each.value.name
  serials    = each.value.serials
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}

locals {
  networks_switch_stacks_routing_interfaces = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for switch_stack in try(network.switch_stacks, []) : [
            for routing_interface in try(switch_stack.routing_interfaces, []) : {
              key                              = format("%s/%s/%s/%s/%s", domain.name, organization.name, network.name, switch_stack.name, routing_interface.name)
              network_id                       = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
              switch_stack_id                  = meraki_switch_stack.networks_switch_stacks[format("%s/%s/%s/%s", domain.name, organization.name, network.name, switch_stack.name)].id
              name                             = try(routing_interface.name, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.name, null)
              subnet                           = try(routing_interface.subnet, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.subnet, null)
              interface_ip                     = try(routing_interface.interface_ip, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.interface_ip, null)
              multicast_routing                = try(routing_interface.multicast_routing, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.multicast_routing, null)
              vlan_id                          = try(routing_interface.vlan_id, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.vlan_id, null)
              default_gateway                  = try(routing_interface.default_gateway, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.default_gateway, null)
              ospf_settings_area               = try(routing_interface.ospf_settings.area, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.ospf_settings.area, null)
              ospf_settings_cost               = try(routing_interface.ospf_settings.cost, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.ospf_settings.cost, null)
              ospf_settings_is_passive_enabled = try(routing_interface.ospf_settings.is_passive, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.ospf_settings.is_passive, null)
              ipv6_assignment_mode             = try(routing_interface.ipv6.assignment_mode, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.ipv6.assignment_mode, null)
              ipv6_prefix                      = try(routing_interface.ipv6.prefix, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.ipv6.prefix, null)
              ipv6_address                     = try(routing_interface.ipv6.address, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.ipv6.address, null)
              ipv6_gateway                     = try(routing_interface.ipv6.gateway, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.ipv6.gateway, null)
            }
          ]
        ]
      ]
    ]
  ])
  networks_switch_stacks_routing_interfaces_first = [
    for routing_interface in local.networks_switch_stacks_routing_interfaces :
    routing_interface
    if routing_interface.default_gateway != null
  ]
  networks_switch_stacks_routing_interfaces_not_first = [
    for routing_interface in local.networks_switch_stacks_routing_interfaces :
    routing_interface
    if routing_interface.default_gateway == null
  ]
}

resource "meraki_switch_stack_routing_interface" "networks_switch_stacks_routing_interfaces_first" {
  for_each                         = { for v in local.networks_switch_stacks_routing_interfaces_first : v.key => v }
  network_id                       = each.value.network_id
  switch_stack_id                  = each.value.switch_stack_id
  name                             = each.value.name
  subnet                           = each.value.subnet
  interface_ip                     = each.value.interface_ip
  multicast_routing                = each.value.multicast_routing
  vlan_id                          = each.value.vlan_id
  default_gateway                  = each.value.default_gateway
  ospf_settings_area               = each.value.ospf_settings_area
  ospf_settings_cost               = each.value.ospf_settings_cost
  ospf_settings_is_passive_enabled = each.value.ospf_settings_is_passive_enabled
  ipv6_assignment_mode             = each.value.ipv6_assignment_mode
  ipv6_prefix                      = each.value.ipv6_prefix
  ipv6_address                     = each.value.ipv6_address
  ipv6_gateway                     = each.value.ipv6_gateway
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}
resource "meraki_switch_stack_routing_interface" "networks_switch_stacks_routing_interfaces_not_first" {
  for_each                         = { for i in local.networks_switch_stacks_routing_interfaces_not_first : i.key => i }
  network_id                       = each.value.network_id
  switch_stack_id                  = each.value.switch_stack_id
  name                             = each.value.name
  subnet                           = each.value.subnet
  interface_ip                     = each.value.interface_ip
  multicast_routing                = each.value.multicast_routing
  vlan_id                          = each.value.vlan_id
  default_gateway                  = each.value.default_gateway
  ospf_settings_area               = each.value.ospf_settings_area
  ospf_settings_cost               = each.value.ospf_settings_cost
  ospf_settings_is_passive_enabled = each.value.ospf_settings_is_passive_enabled
  ipv6_assignment_mode             = each.value.ipv6_assignment_mode
  ipv6_prefix                      = each.value.ipv6_prefix
  ipv6_address                     = each.value.ipv6_address
  ipv6_gateway                     = each.value.ipv6_gateway
  depends_on = [
    meraki_switch_stack_routing_interface.networks_switch_stacks_routing_interfaces_first,
  ]
}

locals {
  networks_switch_stacks_routing_interface_ids = {
    for routing_interface in local.networks_switch_stacks_routing_interfaces :
    routing_interface.key =>
    routing_interface.default_gateway != null ?
    meraki_switch_stack_routing_interface.networks_switch_stacks_routing_interfaces_first[routing_interface.key].id :
    meraki_switch_stack_routing_interface.networks_switch_stacks_routing_interfaces_not_first[routing_interface.key].id
  }
}

locals {
  networks_switch_stacks_routing_interfaces_dhcp = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for switch_stack in try(network.switch_stacks, []) : [
            for routing_interface in try(switch_stack.routing_interfaces, []) : {
              key                    = format("%s/%s/%s/%s/%s", domain.name, organization.name, network.name, switch_stack.name, routing_interface.name)
              network_id             = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
              switch_stack_id        = meraki_switch_stack.networks_switch_stacks[format("%s/%s/%s/%s", domain.name, organization.name, network.name, switch_stack.name)].id
              interface_id           = local.networks_switch_stacks_routing_interface_ids[format("%s/%s/%s/%s/%s", domain.name, organization.name, network.name, switch_stack.name, routing_interface.name)]
              dhcp_mode              = try(routing_interface.dhcp.dhcp_mode, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.dhcp.dhcp_mode, null)
              dhcp_relay_server_ips  = try(routing_interface.dhcp.dhcp_relay_server_ips, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.dhcp.dhcp_relay_server_ips, null)
              dhcp_lease_time        = try(routing_interface.dhcp.dhcp_lease_time, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.dhcp.dhcp_lease_time, null)
              dns_nameservers_option = try(routing_interface.dhcp.dns_nameservers_option, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.dhcp.dns_nameservers_option, null)
              dns_custom_nameservers = try(routing_interface.dhcp.dns_custom_nameservers, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.dhcp.dns_custom_nameservers, null)
              boot_options_enabled   = try(routing_interface.dhcp.boot_options, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.dhcp.boot_options, null)
              boot_next_server       = try(routing_interface.dhcp.boot_next_server, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.dhcp.boot_next_server, null)
              boot_file_name         = try(routing_interface.dhcp.boot_file_name, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.dhcp.boot_file_name, null)
              dhcp_options = try(routing_interface.dhcp.dhcp_options, null) == null ? null : [
                for dhcp_option in try(routing_interface.dhcp.dhcp_options, []) : {
                  code  = try(dhcp_option.code, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.dhcp.dhcp_options.code, null)
                  type  = try(dhcp_option.type, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.dhcp.dhcp_options.type, null)
                  value = try(dhcp_option.value, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.dhcp.dhcp_options.value, null)
                }
              ]
              reserved_ip_ranges = try(routing_interface.dhcp.reserved_ip_ranges, null) == null ? null : [
                for reserved_ip_range in try(routing_interface.dhcp.reserved_ip_ranges, []) : {
                  start   = try(reserved_ip_range.start, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.dhcp.reserved_ip_ranges.start, null)
                  end     = try(reserved_ip_range.end, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.dhcp.reserved_ip_ranges.end, null)
                  comment = try(reserved_ip_range.comment, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.dhcp.reserved_ip_ranges.comment, null)
                }
              ]
              fixed_ip_assignments = try(routing_interface.dhcp.fixed_ip_assignments, null) == null ? null : [
                for fixed_ip_assignment in try(routing_interface.dhcp.fixed_ip_assignments, []) : {
                  name = try(fixed_ip_assignment.name, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.dhcp.fixed_ip_assignments.name, null)
                  mac  = try(fixed_ip_assignment.mac, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.dhcp.fixed_ip_assignments.mac, null)
                  ip   = try(fixed_ip_assignment.ip, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_interfaces.dhcp.fixed_ip_assignments.ip, null)
                }
              ]
            } if try(routing_interface.dhcp, null) != null
          ]
        ]
      ]
    ]
  ])
}

resource "meraki_switch_stack_routing_interface_dhcp" "networks_switch_stacks_routing_interfaces_dhcp" {
  for_each               = { for v in local.networks_switch_stacks_routing_interfaces_dhcp : v.key => v }
  network_id             = each.value.network_id
  switch_stack_id        = each.value.switch_stack_id
  interface_id           = each.value.interface_id
  dhcp_mode              = each.value.dhcp_mode
  dhcp_relay_server_ips  = each.value.dhcp_relay_server_ips
  dhcp_lease_time        = each.value.dhcp_lease_time
  dns_nameservers_option = each.value.dns_nameservers_option
  dns_custom_nameservers = each.value.dns_custom_nameservers
  boot_options_enabled   = each.value.boot_options_enabled
  boot_next_server       = each.value.boot_next_server
  boot_file_name         = each.value.boot_file_name
  dhcp_options           = each.value.dhcp_options
  reserved_ip_ranges     = each.value.reserved_ip_ranges
  fixed_ip_assignments   = each.value.fixed_ip_assignments
}

locals {
  networks_switch_stacks_routing_static_routes = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for switch_stack in try(network.switch_stacks, []) : [
            for routing_static_route in try(switch_stack.routing_static_routes, []) : {
              key                             = format("%s/%s/%s/%s/%s", domain.name, organization.name, network.name, switch_stack.name, routing_static_route.name)
              network_id                      = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
              switch_stack_id                 = meraki_switch_stack.networks_switch_stacks[format("%s/%s/%s/%s", domain.name, organization.name, network.name, switch_stack.name)].id
              name                            = try(routing_static_route.name, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_static_routes.name, null)
              subnet                          = try(routing_static_route.subnet, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_static_routes.subnet, null)
              next_hop_ip                     = try(routing_static_route.next_hop_ip, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_static_routes.next_hop_ip, null)
              advertise_via_ospf_enabled      = try(routing_static_route.advertise_via_ospf, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_static_routes.advertise_via_ospf, null)
              prefer_over_ospf_routes_enabled = try(routing_static_route.prefer_over_ospf_routes, local.defaults.meraki.domains.organizations.networks.switch_stacks.routing_static_routes.prefer_over_ospf_routes, null)
            }
          ]
        ]
      ]
    ]
  ])
}

resource "meraki_switch_stack_routing_static_route" "networks_switch_stacks_routing_static_routes" {
  for_each                        = { for v in local.networks_switch_stacks_routing_static_routes : v.key => v }
  network_id                      = each.value.network_id
  switch_stack_id                 = each.value.switch_stack_id
  name                            = each.value.name
  subnet                          = each.value.subnet
  next_hop_ip                     = each.value.next_hop_ip
  advertise_via_ospf_enabled      = each.value.advertise_via_ospf_enabled
  prefer_over_ospf_routes_enabled = each.value.prefer_over_ospf_routes_enabled
  depends_on = [
    meraki_switch_stack_routing_interface.networks_switch_stacks_routing_interfaces_not_first,
  ]
}
