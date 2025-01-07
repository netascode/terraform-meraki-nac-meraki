# switch_access_lists
locals {
  networks_switch_access_control_lists = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_network.network["${org.name}/${network.name}"].id
          rules = [
            for rule in try(network.switch.access_control_lists.rules, []) : {
              comment    = rule.comment
              dst_cidr   = rule.destination_cidr
              dst_port   = rule.destination_port
              ip_version = rule.ip_version
              policy     = rule.policy
              protocol   = rule.protocol
              src_cidr   = rule.source_cidr
              src_port   = rule.source_port
              vlan       = rule.vlan
            }
          ]
        } if try(network.switch.access_control_lists.rules, null) != null
      ]
    ]
  ])
}
resource "meraki_switch_access_control_lists" "net_switch_access_control_lists" {
  for_each   = { for i, v in local.networks_switch_access_control_lists : i => v }
  network_id = each.value.network_id
  rules      = each.value.rules
}

locals {
  networks_switch_access_policies = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : [
          for switch_access_policy in try(network.switch.access_policies, []) : {
            policy_key = format("%s/%s/switch_access_policies/%s", org.name, network.name, switch_access_policy.name)
            data       = switch_access_policy
            network_id = meraki_network.network["${org.name}/${network.name}"].id
          }
        ] if try(network.switch.access_policies, null) != null
      ]
    ]
  ])
}

resource "meraki_switch_access_policy" "net_switch_access_policy" {
  for_each                                 = { for i, v in local.networks_switch_access_policies : i => v }
  network_id                               = each.value.network_id
  name                                     = try(each.value.data.name, local.defaults.meraki.networks.switch_access_policies.name, null)
  radius_servers                           = try(each.value.data.radius_servers, local.defaults.meraki.networks.switch_access_policies.radius_servers, null)
  radius_critical_auth_data_vlan_id        = try(each.value.data.radius.critical_auth.data_vlan_id, local.defaults.meraki.networks.switch_access_policies.radius.critical_auth.data_vlan_id, null)
  radius_critical_auth_voice_vlan_id       = try(each.value.data.radius.critical_auth.voice_vlan_id, local.defaults.meraki.networks.switch_access_policies.radius.critical_auth.voice_vlan_id, null)
  radius_critical_auth_suspend_port_bounce = try(each.value.data.radius.critical_auth.suspend_port_bounce, local.defaults.meraki.networks.switch_access_policies.radius.critical_auth.suspend_port_bounce, null)
  radius_failed_auth_vlan_id               = try(each.value.data.radius.failed_auth_vlan_id, local.defaults.meraki.networks.switch_access_policies.radius.failed_auth_vlan_id, null)
  radius_re_authentication_interval        = try(each.value.data.radius.re_authentication_interval, local.defaults.meraki.networks.switch_access_policies.radius.re_authentication_interval, null)
  radius_cache_enabled                     = try(each.value.data.radius.cache.enabled, local.defaults.meraki.networks.switch_access_policies.radius.cache.enabled, null)
  radius_cache_timeout                     = try(each.value.data.radius.cache.timeout, local.defaults.meraki.networks.switch_access_policies.radius.cache.timeout, null)
  guest_port_bouncing                      = try(each.value.data.guest_port_bouncing, local.defaults.meraki.networks.switch_access_policies.guest_port_bouncing, null)
  radius_testing_enabled                   = try(each.value.data.radius_testing, local.defaults.meraki.networks.switch_access_policies.radius_testing, null)
  radius_coa_support_enabled               = try(each.value.data.radius_coa_support, local.defaults.meraki.networks.switch_access_policies.radius_coa_support, null)
  radius_accounting_enabled                = try(each.value.data.radius_accounting, local.defaults.meraki.networks.switch_access_policies.radius_accounting, null)
  radius_accounting_servers                = try(each.value.data.radius_accounting_servers, local.defaults.meraki.networks.switch_access_policies.radius_accounting_servers, null)
  radius_group_attribute                   = try(each.value.data.radius_group_attribute, local.defaults.meraki.networks.switch_access_policies.radius_group_attribute, null)
  host_mode                                = try(each.value.data.host_mode, local.defaults.meraki.networks.switch_access_policies.host_mode, null)
  access_policy_type                       = try(each.value.data.access_policy_type, local.defaults.meraki.networks.switch_access_policies.access_policy_type, null)
  increase_access_speed                    = try(each.value.data.increase_access_speed, local.defaults.meraki.networks.switch_access_policies.increase_access_speed, null)
  guest_vlan_id                            = try(each.value.data.guest_vlan_id, local.defaults.meraki.networks.switch_access_policies.guest_vlan_id, null)
  dot1x_control_direction                  = try(each.value.data.dot1x.control_direction, local.defaults.meraki.networks.switch_access_policies.dot1x.control_direction, null)
  voice_vlan_clients                       = try(each.value.data.voice_vlan_clients, local.defaults.meraki.networks.switch_access_policies.voice_vlan_clients, null)
  url_redirect_walled_garden_enabled       = try(each.value.data.url_redirect_walled_garden, local.defaults.meraki.networks.switch_access_policies.url_redirect_walled_garden, null)
  url_redirect_walled_garden_ranges        = try(each.value.data.url_redirect_walled_garden_ranges, local.defaults.meraki.networks.switch_access_policies.url_redirect_walled_garden_ranges, null)
}

locals {
  networks_switch_alternate_management_interface = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_network.network["${org.name}/${network.name}"].id
          data       = network.switch.alternate_management_interface
        } if try(network.switch.alternate_management_interface, null) != null
      ]
    ]
  ])
}

resource "meraki_switch_alternate_management_interface" "net_switch_alternate_management_interface" {
  for_each   = { for i, v in local.networks_switch_alternate_management_interface : i => v }
  network_id = each.value.network_id
  enabled    = try(each.value.data.enabled, local.defaults.meraki.networks.switch_alternate_management_interface.enabled, null)
  vlan_id    = try(each.value.data.vlan_id, local.defaults.meraki.networks.switch_alternate_management_interface.vlan_id, null)
  protocols  = try(each.value.data.protocols, local.defaults.meraki.networks.switch_alternate_management_interface.protocols, null)
  switches   = try(each.value.data.switches, local.defaults.meraki.networks.switch_alternate_management_interface.switches, null)

}

locals {
  networks_switch_dhcp_server_policy = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_network.network["${org.name}/${network.name}"].id
          data       = network.switch.dhcp_server_policy
        } if try(network.switch.dhcp_server_policy, null) != null
      ]
    ]
  ])
}

resource "meraki_switch_dhcp_server_policy" "net_switch_dhcp_server_policy" {
  for_each               = { for i, v in local.networks_switch_dhcp_server_policy : i => v }
  network_id             = each.value.network_id
  alerts_email_enabled   = try(each.value.data.alerts.email.enabled, local.defaults.meraki.networks.switch_dhcp_server_policy.alerts.email.enabled, null)
  default_policy         = try(each.value.data.default_policy, local.defaults.meraki.networks.switch_dhcp_server_policy.default_policy, null)
  allowed_servers        = try(each.value.data.allowed_servers, local.defaults.meraki.networks.switch_dhcp_server_policy.allowed_servers, null)
  blocked_servers        = try(each.value.data.blocked_servers, local.defaults.meraki.networks.switch_dhcp_server_policy.blocked_servers, null)
  arp_inspection_enabled = try(each.value.data.arp_inspection.enabled, local.defaults.meraki.networks.switch_dhcp_server_policy.arp_inspection.enabled, null)

}


locals {
  networks_switch_dhcp_server_policy_arp_inspection_trusted_servers = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : [
          for trusted_server in try(network.switch.dhcp_server_policy_arp_inspection_trusted_servers, []) : {
            data       = trusted_server
            network_id = meraki_network.network["${org.name}/${network.name}"].id
          }
        ] if try(network.switch.dhcp_server_policy_arp_inspection_trusted_servers, null) != null
      ]
    ]
  ])
}

resource "meraki_switch_dhcp_server_policy_arp_inspection_trusted_server" "net_switch_dhcp_server_policy_arp_inspection_trusted_server" {
  for_each     = { for i, v in local.networks_switch_dhcp_server_policy_arp_inspection_trusted_servers : i => v }
  network_id   = each.value.network_id
  mac          = try(each.value.data.mac, local.defaults.meraki.networks.switch_dhcp_server_policy_arp_inspection_trusted_servers.mac, null)
  vlan         = try(each.value.data.vlan, local.defaults.meraki.networks.switch_dhcp_server_policy_arp_inspection_trusted_servers.vlan, null)
  ipv4_address = try(each.value.data.ipv4.address, local.defaults.meraki.networks.switch_dhcp_server_policy_arp_inspection_trusted_servers.ipv4.address, null)
}
locals {
  networks_switch_dscp_to_cos_mappings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_network.network["${org.name}/${network.name}"].id
          data       = network.switch.dscp_to_cos_mappings
        } if try(network.switch.dscp_to_cos_mappings, null) != null
      ]
    ]
  ])
}

resource "meraki_switch_dscp_to_cos_mappings" "net_switch_dscp_to_cos_mappings" {
  for_each   = { for i, v in local.networks_switch_dscp_to_cos_mappings : i => v }
  network_id = each.value.network_id
  mappings   = try(each.value.data.mappings, local.defaults.meraki.networks.switch_dscp_to_cos_mappings.mappings, null)
  depends_on = [meraki_network_device_claim.net_device_claim]
}


locals {
  networks_switch_link_aggregations = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for switch_link_aggregation in try(network.switch.link_aggregations, []) : {
            network_id = meraki_network.network["${organization.name}/${network.name}"].id
            switch_ports = [for p in switch_link_aggregation.switch_ports : {
              serial  = meraki_device.device["${organization.name}/${network.name}/devices/${p.device}"].serial
              port_id = p.port_id
            }]
            data = try(switch_link_aggregation, null)
          } if try(network.switch.link_aggregations, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}
resource "meraki_switch_link_aggregation" "net_switch_link_aggregation" {
  for_each             = { for i, v in local.networks_switch_link_aggregations : i => v }
  network_id           = each.value.network_id
  switch_ports         = each.value.switch_ports
  switch_profile_ports = try(each.value.data.switch_profile_ports, local.defaults.meraki.networks.networks_switch_link_aggregations.switch_profile_ports, null)
  depends_on           = [meraki_switch_stack.net_switch_stacks]
}



locals {
  networks_switch_mtu = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.switch.mtu, null)
        } if try(network.switch.mtu, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_switch_mtu" "net_switch_mtu" {
  for_each         = { for i, v in local.networks_switch_mtu : i => v }
  network_id       = each.value.network_id
  default_mtu_size = try(each.value.data.default_mtu_size, local.defaults.meraki.networks.networks_switch.mtu.default_mtu_size, null)
  overrides        = try(each.value.data.overrides, local.defaults.meraki.networks.networks_switch.mtu.overrides, null)
  depends_on       = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_switch_port_schedules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for switch_port_schedule in try(network.switch.port_schedules, []) : {
            network_id = meraki_network.network["${organization.name}/${network.name}"].id
            key        = format("%s/%s/port_schedules/%s", organization.name, network.name, switch_port_schedule.name)
            data       = try(switch_port_schedule, null)
          } if try(network.switch.port_schedules, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_switch_port_schedule" "net_switch_port_schedules" {
  for_each                       = { for i in local.networks_switch_port_schedules : i.key => i }
  network_id                     = each.value.network_id
  name                           = try(each.value.data.name, local.defaults.meraki.networks.networks.switch.port_schedules.name, null)
  port_schedule_monday_active    = try(each.value.data.port_schedule.monday.active, local.defaults.meraki.networks.networks.switch.port_schedules.port_schedule.monday.active, null)
  port_schedule_monday_from      = try(each.value.data.port_schedule.monday.from, local.defaults.meraki.networks.networks.switch.port_schedules.port_schedule.monday.from, null)
  port_schedule_monday_to        = try(each.value.data.port_schedule.monday.to, local.defaults.meraki.networks.networks.switch.port_schedules.port_schedule.monday.to, null)
  port_schedule_tuesday_active   = try(each.value.data.port_schedule.tuesday.active, local.defaults.meraki.networks.networks.switch.port_schedules.port_schedule.tuesday.active, null)
  port_schedule_tuesday_from     = try(each.value.data.port_schedule.tuesday.from, local.defaults.meraki.networks.networks.switch.port_schedules.port_schedule.tuesday.from, null)
  port_schedule_tuesday_to       = try(each.value.data.port_schedule.tuesday.to, local.defaults.meraki.networks.networks.switch.port_schedules.port_schedule.tuesday.to, null)
  port_schedule_wednesday_active = try(each.value.data.port_schedule.wednesday.active, local.defaults.meraki.networks.networks.switch.port_schedules.port_schedule.wednesday.active, null)
  port_schedule_wednesday_from   = try(each.value.data.port_schedule.wednesday.from, local.defaults.meraki.networks.networks.switch.port_schedules.port_schedule.wednesday.from, null)
  port_schedule_wednesday_to     = try(each.value.data.port_schedule.wednesday.to, local.defaults.meraki.networks.networks.switch.port_schedules.port_schedule.wednesday.to, null)
  port_schedule_thursday_active  = try(each.value.data.port_schedule.thursday.active, local.defaults.meraki.networks.networks.switch.port_schedules.port_schedule.thursday.active, null)
  port_schedule_thursday_from    = try(each.value.data.port_schedule.thursday.from, local.defaults.meraki.networks.networks.switch.port_schedules.port_schedule.thursday.from, null)
  port_schedule_thursday_to      = try(each.value.data.port_schedule.thursday.to, local.defaults.meraki.networks.networks.switch.port_schedules.port_schedule.thursday.to, null)
  port_schedule_friday_active    = try(each.value.data.port_schedule.friday.active, local.defaults.meraki.networks.networks.switch.port_schedules.port_schedule.friday.active, null)
  port_schedule_friday_from      = try(each.value.data.port_schedule.friday.from, local.defaults.meraki.networks.networks.switch.port_schedules.port_schedule.friday.from, null)
  port_schedule_friday_to        = try(each.value.data.port_schedule.friday.to, local.defaults.meraki.networks.networks.switch.port_schedules.port_schedule.friday.to, null)
  port_schedule_saturday_active  = try(each.value.data.port_schedule.saturday.active, local.defaults.meraki.networks.networks.switch.port_schedules.port_schedule.saturday.active, null)
  port_schedule_saturday_from    = try(each.value.data.port_schedule.saturday.from, local.defaults.meraki.networks.networks.switch.port_schedules.port_schedule.saturday.from, null)
  port_schedule_saturday_to      = try(each.value.data.port_schedule.saturday.to, local.defaults.meraki.networks.networks.switch.port_schedules.port_schedule.saturday.to, null)
  port_schedule_sunday_active    = try(each.value.data.port_schedule.sunday.active, local.defaults.meraki.networks.networks.switch.port_schedules.port_schedule.sunday.active, null)
  port_schedule_sunday_from      = try(each.value.data.port_schedule.sunday.from, local.defaults.meraki.networks.networks.switch.port_schedules.port_schedule.sunday.from, null)
  port_schedule_sunday_to        = try(each.value.data.port_schedule.sunday.to, local.defaults.meraki.networks.networks.switch.port_schedules.port_schedule.sunday.to, null)
  depends_on                     = [meraki_network_device_claim.net_device_claim]
}


locals {
  networks_switch_qos_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for switch_qos_rule in try(network.switch.qos_rules, []) : {
            network_id = meraki_network.network["${organization.name}/${network.name}"].id
            key        = "${organization.name}/${network.name}/qos_rules/${switch_qos_rule.qos_rule_name}"
            data       = try(switch_qos_rule, null)
          } if try(network.switch.qos_rules, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_switch_qos_rule" "net_switch_qos_rule" {
  for_each       = { for i, v in local.networks_switch_qos_rules : v.key => v }
  network_id     = each.value.network_id
  vlan           = try(each.value.data.vlan, local.defaults.meraki.networks.networks_switch_qos_rules.vlan, null)
  protocol       = try(each.value.data.protocol, local.defaults.meraki.networks.networks_switch_qos_rules.protocol, null)
  src_port       = try(each.value.data.source_port, local.defaults.meraki.networks.networks_switch_qos_rules.source_port, null)
  src_port_range = try(each.value.data.source_port_range, local.defaults.meraki.networks.networks_switch_qos_rules.source_port_range, null)
  dst_port       = try(each.value.data.destination_port, local.defaults.meraki.networks.networks_switch_qos_rules.destination_port, null)
  dst_port_range = try(each.value.data.destination_port_range, local.defaults.meraki.networks.networks_switch_qos_rules.destination_port_range, null)
  dscp           = try(each.value.data.dscp, local.defaults.meraki.networks.networks_switch_qos_rules.dscp, null)
  depends_on     = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_switch_qos_rules_orders = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          rule_ids   = [for r in network.switch.qos_rules : meraki_switch_qos_rule.net_switch_qos_rule["${organization.name}/${network.name}/qos_rules/${r.qos_rule_name}"].id]
        } if try(network.switch.qos_rules, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_switch_qos_rule_order" "net_switch_qos_rule_order" {
  for_each   = { for i, v in local.networks_switch_qos_rules_orders : i => v }
  network_id = each.value.network_id
  rule_ids   = each.value.rule_ids
}

locals {
  networks_switch_routing_multicast = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.switch.routing_multicast, null)
        } if try(network.switch.routing_multicast, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_switch_routing_multicast" "net_switch_routing_multicast" {
  for_each                                                 = { for i, v in local.networks_switch_routing_multicast : i => v }
  network_id                                               = each.value.network_id
  default_settings_igmp_snooping_enabled                   = try(each.value.data.default_settings.igmp_snooping, local.defaults.meraki.networks.networks_switch_routing_multicast.default_settings.igmp_snooping, null)
  default_settings_flood_unknown_multicast_traffic_enabled = try(each.value.data.default_settings.flood_unknown_multicast_traffic, local.defaults.meraki.networks.networks_switch_routing_multicast.default_settings.flood_unknown_multicast_traffic, null)
  overrides                                                = try(each.value.data.overrides, local.defaults.meraki.networks.networks_switch_routing_multicast.overrides, null)
  depends_on                                               = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_switch_routing_multicast_rendezvous_points = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for switch_routing_multicast_rendezvous_point in try(network.switch.routing_multicast_rendezvous_points, []) : {
            network_id = meraki_network.network["${organization.name}/${network.name}"].id
            data       = try(switch_routing_multicast_rendezvous_point, null)
          } if try(network.switch.routing_multicast_rendezvous_points, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_switch_routing_multicast_rendezvous_point" "net_switch_routing_multicast_rendezvous_point" {
  for_each        = { for i, v in local.networks_switch_routing_multicast_rendezvous_points : i => v }
  network_id      = each.value.network_id
  interface_ip    = try(each.value.data.interface_ip, local.defaults.meraki.networks.networks_switch_routing_multicast_rendezvous_points.interface_ip, null)
  multicast_group = try(each.value.data.multicast_group, local.defaults.meraki.networks.networks_switch_routing_multicast_rendezvous_points.multicast_group, null)
  depends_on      = [meraki_switch_stack_routing_interface.net_switch_stack_routing_interface_not_first]
}

locals {
  networks_switch_routing_ospf = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.switch.routing_ospf, null)
        } if try(network.switch.routing_ospf, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_switch_routing_ospf" "net_switch_routing_ospf" {
  for_each                          = { for i, v in local.networks_switch_routing_ospf : i => v }
  network_id                        = each.value.network_id
  enabled                           = try(each.value.data.enabled, local.defaults.meraki.networks.networks_switch_routing_ospf.enabled, null)
  hello_timer_in_seconds            = try(each.value.data.hello_timer_in_seconds, local.defaults.meraki.networks.networks_switch_routing_ospf.hello_timer_in_seconds, null)
  dead_timer_in_seconds             = try(each.value.data.dead_timer_in_seconds, local.defaults.meraki.networks.networks_switch_routing_ospf.dead_timer_in_seconds, null)
  areas                             = try(each.value.data.areas, local.defaults.meraki.networks.networks_switch_routing_ospf.areas, null)
  v3_enabled                        = try(each.value.data.v3.enabled, local.defaults.meraki.networks.networks_switch_routing_ospf.v3.enabled, null)
  v3_hello_timer_in_seconds         = try(each.value.data.v3.hello_timer_in_seconds, local.defaults.meraki.networks.networks_switch_routing_ospf.v3.hello_timer_in_seconds, null)
  v3_dead_timer_in_seconds          = try(each.value.data.v3.dead_timer_in_seconds, local.defaults.meraki.networks.networks_switch_routing_ospf.v3.dead_timer_in_seconds, null)
  v3_areas                          = try(each.value.data.v3.areas, local.defaults.meraki.networks.networks_switch_routing_ospf.v3.areas, null)
  md5_authentication_enabled        = try(each.value.data.md5_authentication, local.defaults.meraki.networks.networks_switch_routing_ospf.md5_authentication_enabled, null)
  md5_authentication_key_id         = try(each.value.data.md5_authentication_key.id, local.defaults.meraki.networks.networks_switch_routing_ospf.md5_authentication_key.id, null)
  md5_authentication_key_passphrase = try(each.value.data.md5_authentication_key.passphrase, local.defaults.meraki.networks.networks_switch_routing_ospf.md5_authentication_key.passphrase, null)
  depends_on                        = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_switch_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.switch.settings, null)
        } if try(network.switch.settings, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_switch_settings" "net_switch_settings" {
  for_each                       = { for i, v in local.networks_switch_settings : i => v }
  network_id                     = each.value.network_id
  vlan                           = try(each.value.data.vlan, local.defaults.meraki.networks.networks_switch_settings.vlan, null)
  use_combined_power             = try(each.value.data.use_combined_power, local.defaults.meraki.networks.networks_switch_settings.use_combined_power, null)
  power_exceptions               = try(each.value.data.power_exceptions, local.defaults.meraki.networks.networks_switch_settings.power_exceptions, null)
  uplink_client_sampling_enabled = try(each.value.data.uplink_client_sampling.enabled, local.defaults.meraki.networks.networks_switch_settings.uplink_client_sampling.enabled, null)
  mac_blocklist_enabled          = try(each.value.data.mac_blocklist.enabled, local.defaults.meraki.networks.networks_switch_settings.mac_blocklist.enabled, null)
  depends_on                     = [meraki_network_device_claim.net_device_claim]
}
locals {
  networks_switch_storm_control = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          network_id = meraki_network.network["${organization.name}/${network.name}"].id
          data       = try(network.switch.storm_control, null)
        } if try(network.switch.storm_control, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_switch_storm_control" "net_switch_storm_control" {
  for_each                  = { for i, v in local.networks_switch_storm_control : i => v }
  network_id                = each.value.network_id
  broadcast_threshold       = try(each.value.data.broadcast_threshold, local.defaults.meraki.networks.networks_switch_storm_control.broadcast_threshold, null)
  multicast_threshold       = try(each.value.data.multicast_threshold, local.defaults.meraki.networks.networks_switch_storm_control.multicast_threshold, null)
  unknown_unicast_threshold = try(each.value.data.unknown_unicast_threshold, local.defaults.meraki.networks.networks_switch_storm_control.unknown_unicast_threshold, null)
  depends_on                = [meraki_network_device_claim.net_device_claim]
}

locals {
  switch_stack_map = {
    for i, s in meraki_switch_stack.net_switch_stacks : i => s.id
  }
}

locals {
  networks_switch_stp = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_network.network["${org.name}/${network.name}"].id
          data       = network.switch.stp
          stp_bridge_priority = [for p in network.switch.stp.stp_bridge_priority : {
            switches     = try(p.switches, null)
            stp_priority = try(p.stp_priority, null)
            stacks = length(try(p.stacks, [])) > 0 ? [
              for s in p.stacks :
              local.switch_stack_map["${org.name}/${network.name}/switch_stacks/${s}"]
            ] : null
          }]
        } if try(network.switch.stp, null) != null
      ]
    ]
  ])
}

resource "meraki_switch_stp" "net_switch_stp" {
  for_each            = { for i, v in local.networks_switch_stp : i => v }
  network_id          = each.value.network_id
  rstp_enabled        = try(each.value.data.rstp, local.defaults.meraki.networks.switch_stp.rstp_enabled, null)
  stp_bridge_priority = try(each.value.stp_bridge_priority, [])
  depends_on          = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_switch_stacks = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for switch_stack in try(network.switch_stacks, []) : {
            network_id = meraki_network.network["${organization.name}/${network.name}"].id
            stack_key  = format("%s/%s/switch_stacks/%s", organization.name, network.name, switch_stack.name)
            data       = switch_stack
            serials    = [for d in switch_stack.devices : meraki_device.device["${organization.name}/${network.name}/devices/${d}"].serial]
          } if try(network.switch_stacks, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_switch_stack" "net_switch_stacks" {
  for_each   = { for s in local.networks_switch_stacks : s.stack_key => s }
  network_id = each.value.network_id
  name       = try(each.value.data.name, local.defaults.meraki.networks.networks_switch_stacks.name, null)
  serials    = each.value.serials
  depends_on = [meraki_network_device_claim.net_device_claim]
}

locals {
  networks_switch_stacks_routing_interfaces_first = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for switch_stack in try(network.switch_stacks, []) : [
            for routing_interface in try(switch_stack.routing_interfaces, []) : {
              network_id      = meraki_network.network["${organization.name}/${network.name}"].id
              interface_key   = format("%s/%s/switch_stacks/%s/routing_interfaces/%s", organization.name, network.name, switch_stack.name, routing_interface.name)
              switch_stack_id = meraki_switch_stack.net_switch_stacks["${organization.name}/${network.name}/switch_stacks/${switch_stack.name}"].id
              data            = try(routing_interface, null)
            } if try(routing_interface.default_gateway, null) != null
          ] if try(network.switch_stacks, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
  networks_switch_stacks_routing_interfaces_not_first = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for switch_stack in try(network.switch_stacks, []) : [
            for routing_interface in try(switch_stack.routing_interfaces, []) : {
              network_id      = meraki_network.network["${organization.name}/${network.name}"].id
              interface_key   = format("%s/%s/switch_stacks/%s/routing_interfaces/%s", organization.name, network.name, switch_stack.name, routing_interface.name)
              switch_stack_id = meraki_switch_stack.net_switch_stacks["${organization.name}/${network.name}/switch_stacks/${switch_stack.name}"].id
              data            = try(routing_interface, null)
            } if try(routing_interface.default_gateway, null) == null
          ] if try(network.switch_stacks, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_switch_stack_routing_interface" "net_switch_stack_routing_interface_first" {
  for_each                         = { for i in local.networks_switch_stacks_routing_interfaces_first : i.interface_key => i }
  network_id                       = each.value.network_id
  switch_stack_id                  = each.value.switch_stack_id
  name                             = try(each.value.data.name, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces.name, null)
  subnet                           = try(each.value.data.subnet, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces.subnet, null)
  interface_ip                     = try(each.value.data.interface_ip, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces.interface_ip, null)
  multicast_routing                = try(each.value.data.multicast_routing, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces.multicast_routing, null)
  vlan_id                          = try(each.value.data.vlan_id, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces.vlan_id, null)
  default_gateway                  = try(each.value.data.default_gateway, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces.default_gateway, null)
  ospf_settings_area               = try(each.value.data.ospf_settings.area, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces.ospf_settings.area, null)
  ospf_settings_cost               = try(each.value.data.ospf_settings.cost, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces.ospf_settings.cost, null)
  ospf_settings_is_passive_enabled = try(each.value.data.ospf_settings.is_passive, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces.ospf_settings.is_passive, null)
  ipv6_assignment_mode             = try(each.value.data.ipv6.assignment_mode, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces.ipv6.assignment_mode, null)
  ipv6_prefix                      = try(each.value.data.ipv6.prefix, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces.ipv6.prefix, null)
  ipv6_address                     = try(each.value.data.ipv6.address, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces.ipv6.address, null)
  ipv6_gateway                     = try(each.value.data.ipv6.gateway, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces.ipv6.gateway, null)
  depends_on                       = [meraki_network_device_claim.net_device_claim]
}
resource "meraki_switch_stack_routing_interface" "net_switch_stack_routing_interface_not_first" {
  for_each                         = { for i in local.networks_switch_stacks_routing_interfaces_not_first : i.interface_key => i }
  network_id                       = each.value.network_id
  switch_stack_id                  = each.value.switch_stack_id
  name                             = try(each.value.data.name, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces.name, null)
  subnet                           = try(each.value.data.subnet, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces.subnet, null)
  interface_ip                     = try(each.value.data.interface_ip, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces.interface_ip, null)
  multicast_routing                = try(each.value.data.multicast_routing, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces.multicast_routing, null)
  vlan_id                          = try(each.value.data.vlan_id, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces.vlan_id, null)
  default_gateway                  = try(each.value.data.default_gateway, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces.default_gateway, null)
  ospf_settings_area               = try(each.value.data.ospf_settings.area, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces.ospf_settings.area, null)
  ospf_settings_cost               = try(each.value.data.ospf_settings.cost, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces.ospf_settings.cost, null)
  ospf_settings_is_passive_enabled = try(each.value.data.ospf_settings.is_passive, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces.ospf_settings.is_passive, null)
  ipv6_assignment_mode             = try(each.value.data.ipv6.assignment_mode, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces.ipv6.assignment_mode, null)
  ipv6_prefix                      = try(each.value.data.ipv6.prefix, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces.ipv6.prefix, null)
  ipv6_address                     = try(each.value.data.ipv6.address, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces.ipv6.address, null)
  ipv6_gateway                     = try(each.value.data.ipv6.gateway, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces.ipv6.gateway, null)
  depends_on                       = [meraki_switch_stack_routing_interface.net_switch_stack_routing_interface_first]
}

locals {
  networks_switch_stacks_routing_interfaces_dhcp_first = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for switch_stack in try(network.switch_stacks, []) : [
            for routing_interface in try(switch_stack.routing_interfaces, []) : {
              network_id      = meraki_network.network["${organization.name}/${network.name}"].id
              switch_stack_id = meraki_switch_stack.net_switch_stacks["${organization.name}/${network.name}/switch_stacks/${switch_stack.name}"].id
              interface_id    = meraki_switch_stack_routing_interface.net_switch_stack_routing_interface_first["${organization.name}/${network.name}/switch_stacks/${switch_stack.name}/routing_interfaces/${routing_interface.name}"].id
              data            = try(routing_interface.dhcp[0], null) # Take the first element of the dhcp list
            } if try(routing_interface.default_gateway, null) != null
          ] if try(network.switch_stacks, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_switch_stack_routing_interface_dhcp" "net_switch_stacks_routing_interfaces_dhcp_first" {
  for_each               = { for i, v in local.networks_switch_stacks_routing_interfaces_dhcp_first : i => v }
  network_id             = each.value.network_id
  switch_stack_id        = each.value.switch_stack_id
  interface_id           = each.value.interface_id
  dhcp_mode              = try(each.value.data.dhcp_mode, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces_dhcp.dhcp_mode, null)
  dhcp_relay_server_ips  = try(each.value.data.dhcp_relay_server_ips, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces_dhcp.dhcp_relay_server_ips, null)
  dhcp_lease_time        = try(each.value.data.dhcp_lease_time, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces_dhcp.dhcp_lease_time, null)
  dns_nameservers_option = try(each.value.data.dns_nameservers_option, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces_dhcp.dns_nameservers_option, null)
  dns_custom_nameservers = try(each.value.data.dns_custom_nameservers, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces_dhcp.dns_custom_nameservers, null)
  boot_options_enabled   = try(each.value.data.boot_options, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces_dhcp.boot_options, null)
  boot_next_server       = try(each.value.data.boot_next_server, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces_dhcp.boot_next_server, null)
  boot_file_name         = try(each.value.data.boot_file_name, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces_dhcp.boot_file_name, null)
  dhcp_options           = try(each.value.data.dhcp_options, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces_dhcp.dhcp_options, null)
  reserved_ip_ranges     = try(each.value.data.reserved_ip_ranges, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces_dhcp.reserved_ip_ranges, null)
  fixed_ip_assignments   = try(each.value.data.fixed_ip_assignments, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces_dhcp.fixed_ip_assignments, null)
  depends_on             = [meraki_switch_stack_routing_interface.net_switch_stack_routing_interface_first]
}

locals {
  networks_switch_stacks_routing_interfaces_dhcp_not_first = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for switch_stack in try(network.switch_stacks, []) : [
            for routing_interface in try(switch_stack.routing_interfaces, []) : {
              network_id      = meraki_network.network["${organization.name}/${network.name}"].id
              switch_stack_id = meraki_switch_stack.net_switch_stacks["${organization.name}/${network.name}/switch_stacks/${switch_stack.name}"].id
              interface_id    = meraki_switch_stack_routing_interface.net_switch_stack_routing_interface_not_first["${organization.name}/${network.name}/switch_stacks/${switch_stack.name}/routing_interfaces/${routing_interface.name}"].id
              data            = try(routing_interface.dhcp[0], null) # Take the first element of the dhcp list
            } if try(routing_interface.default_gateway, null) == null
          ] if try(network.switch_stacks, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_switch_stack_routing_interface_dhcp" "net_switch_stacks_routing_interfaces_dhcp_not_first" {
  for_each               = { for i, v in local.networks_switch_stacks_routing_interfaces_dhcp_not_first : i => v }
  network_id             = each.value.network_id
  switch_stack_id        = each.value.switch_stack_id
  interface_id           = each.value.interface_id
  dhcp_mode              = try(each.value.data.dhcp_mode, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces_dhcp.dhcp_mode, null)
  dhcp_relay_server_ips  = try(each.value.data.dhcp_relay_server_ips, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces_dhcp.dhcp_relay_server_ips, null)
  dhcp_lease_time        = try(each.value.data.dhcp_lease_time, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces_dhcp.dhcp_lease_time, null)
  dns_nameservers_option = try(each.value.data.dns_nameservers_option, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces_dhcp.dns_nameservers_option, null)
  dns_custom_nameservers = try(each.value.data.dns_custom_nameservers, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces_dhcp.dns_custom_nameservers, null)
  boot_options_enabled   = try(each.value.data.boot_options, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces_dhcp.boot_options, null)
  boot_next_server       = try(each.value.data.boot_next_server, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces_dhcp.boot_next_server, null)
  boot_file_name         = try(each.value.data.boot_file_name, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces_dhcp.boot_file_name, null)
  dhcp_options           = try(each.value.data.dhcp_options, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces_dhcp.dhcp_options, null)
  reserved_ip_ranges     = try(each.value.data.reserved_ip_ranges, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces_dhcp.reserved_ip_ranges, null)
  fixed_ip_assignments   = try(each.value.data.fixed_ip_assignments, local.defaults.meraki.networks.networks_switch_stacks_routing_interfaces_dhcp.fixed_ip_assignments, null)
  depends_on             = [meraki_switch_stack_routing_interface.net_switch_stack_routing_interface_not_first]
}

locals {
  networks_switch_stacks_routing_static_routes = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for switch_stack in try(network.switch_stacks, []) : [
            for routing_static_route in try(switch_stack.routing_static_routes, []) : {
              network_id      = meraki_network.network["${organization.name}/${network.name}"].id
              switch_stack_id = meraki_switch_stack.net_switch_stacks["${organization.name}/${network.name}/switch_stacks/${switch_stack.name}"].id
              data            = try(routing_static_route, null)
            } if try(switch_stack.routing_static_routes, null) != null
          ] if try(network.switch_stacks, null) != null
        ] if try(organization.networks, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_switch_stack_routing_static_route" "net_switch_stacks_routing_static_route" {
  for_each                        = { for i, v in local.networks_switch_stacks_routing_static_routes : i => v }
  network_id                      = each.value.network_id
  switch_stack_id                 = each.value.switch_stack_id
  name                            = try(each.value.data.name, local.defaults.meraki.networks.networks_switch_stacks_routing_static_routes.name, null)
  subnet                          = try(each.value.data.subnet, local.defaults.meraki.networks.networks_switch_stacks_routing_static_routes.subnet, null)
  next_hop_ip                     = try(each.value.data.next_hop_ip, local.defaults.meraki.networks.networks_switch_stacks_routing_static_routes.next_hop_ip, null)
  advertise_via_ospf_enabled      = try(each.value.data.advertise_via_ospf, local.defaults.meraki.networks.networks_switch_stacks_routing_static_routes.advertise_via_ospf, null)
  prefer_over_ospf_routes_enabled = try(each.value.data.prefer_over_ospf_routes, local.defaults.meraki.networks.networks_switch_stacks_routing_static_routes.prefer_over_ospf_routes, null)
  depends_on                      = [meraki_switch_stack_routing_interface.net_switch_stack_routing_interface_not_first]
}
