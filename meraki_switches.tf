locals {
  networks_switch_access_control_lists = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = network.switch_access_control_lists
        } if try(network.switch_access_control_lists, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_access_control_lists" "net_switch_access_control_lists" {
  for_each   = { for i, v in local.networks_switch_access_control_lists : i => v }
  network_id = each.value.network_id
  rules      = try(each.value.data.rules, local.defaults.meraki.networks.switch_access_control_lists, null)
  # rules_response = try(each.value.data.rules_response, null)
}

locals {
  networks_switch_access_policies = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : [
          for switch_access_policy in try(network.switch_access_policies, []) : {
            policy_key = format("%s/%s/%s/switch_access_policies/%s", domain.name, org.name, network.name, switch_access_policy.name)
            data       = switch_access_policy
            network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          }
        ] if try(network.switch_access_policies, null) != null
        # for network in try(org.networks, []) : {
        #   network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
        #   data       = network.switch_access_policies
        # } if try(network.switch_access_policies, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_access_policies" "net_switch_access_policies" {
  for_each             = { for i, v in local.networks_switch_access_policies : i => v }
  network_id           = each.value.network_id
  access_policy_number = try(each.value.data.access_policy_number, local.defaults.meraki.networks.switch_access_policies.access_policy_number, null)
  access_policy_type   = try(each.value.data.access_policy_type, local.defaults.meraki.networks.switch_access_policies.access_policy_type, null)
  # counts = try(each.value.data.counts, local.defaults.meraki.networks.switch_access_policies.counts, null)
  dot1x                     = try(each.value.data.dot1x, local.defaults.meraki.networks.switch_access_policies.dot1x, null)
  guest_port_bouncing       = try(each.value.data.guest_port_bouncing, local.defaults.meraki.networks.switch_access_policies.guest_port_bouncing, null)
  guest_vlan_id             = try(each.value.data.guest_vlan_id, local.defaults.meraki.networks.switch_access_policies.guest_vlan_id, null)
  host_mode                 = try(each.value.data.host_mode, local.defaults.meraki.networks.switch_access_policies.host_mode, null)
  increase_access_speed     = try(each.value.data.increase_access_speed, local.defaults.meraki.networks.switch_access_policies.increase_access_speed, null)
  name                      = try(each.value.data.name, local.defaults.meraki.networks.switch_access_policies.name, null)
  radius                    = try(each.value.data.radius, local.defaults.meraki.networks.switch_access_policies.radius, null)
  radius_accounting_enabled = try(each.value.data.radius_accounting_enabled, local.defaults.meraki.networks.switch_access_policies.radius_accounting_enabled, null)
  radius_accounting_servers = try(each.value.data.radius_accounting_servers, local.defaults.meraki.networks.switch_access_policies.radius_accounting_servers, null)
  # radius_accounting_servers_response = try(each.value.data.radius_accounting_servers_response, local.defaults.meraki.networks.switch_access_policies.radius_accounting_servers_response, null)
  radius_coa_support_enabled = try(each.value.data.radius_coa_support_enabled, local.defaults.meraki.networks.switch_access_policies.radius_coa_support_enabled, null)
  radius_group_attribute     = try(each.value.data.radius_group_attribute, local.defaults.meraki.networks.switch_access_policies.radius_group_attribute, null)
  radius_servers             = try(each.value.data.radius_servers, local.defaults.meraki.networks.switch_access_policies.radius_servers, null)
  # radius_servers_response = try(each.value.data.radius_servers_response, local.defaults.meraki.networks.switch_access_policies.radius_servers_response, null)
  radius_testing_enabled             = try(each.value.data.radius_testing_enabled, local.defaults.meraki.networks.switch_access_policies.radius_testing_enabled, null)
  url_redirect_walled_garden_enabled = try(each.value.data.url_redirect_walled_garden_enabled, local.defaults.meraki.networks.switch_access_policies.url_redirect_walled_garden_enabled, null)
  url_redirect_walled_garden_ranges  = try(each.value.data.url_redirect_walled_garden_ranges, local.defaults.meraki.networks.switch_access_policies.url_redirect_walled_garden_ranges, null)
  voice_vlan_clients                 = try(each.value.data.voice_vlan_clients, local.defaults.meraki.networks.switch_access_policies.voice_vlan_clients, null)
}



locals {
  networks_switch_alternate_management_interface = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = network.switch_alternate_management_interface
        } if try(network.switch_alternate_management_interface, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_alternate_management_interface" "net_switch_alternate_management_interface" {
  for_each   = { for i, v in local.networks_switch_alternate_management_interface : i => v }
  network_id = each.value.network_id
  enabled    = try(each.value.data.enabled, local.defaults.meraki.networks.switch_alternate_management_interface.enabled, null)
  protocols  = try(each.value.data.protocols, local.defaults.meraki.networks.switch_alternate_management_interface.protocols, null)
  switches   = try(each.value.data.switches, local.defaults.meraki.networks.switch_alternate_management_interface.switches, null)
  vlan_id    = try(each.value.data.vlan_id, local.defaults.meraki.networks.switch_alternate_management_interface.vlan_id, null)
}



locals {
  networks_switch_dhcp_server_policy = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = network.switch_dhcp_server_policy
        } if try(network.switch_dhcp_server_policy, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_dhcp_server_policy" "net_switch_dhcp_server_policy" {
  for_each        = { for i, v in local.networks_switch_dhcp_server_policy : i => v }
  network_id      = each.value.network_id
  alerts          = try(each.value.data.alerts, local.defaults.meraki.networks.switch_dhcp_server_policy.alerts, null)
  allowed_servers = try(each.value.data.allowed_servers, local.defaults.meraki.networks.switch_dhcp_server_policy.allowed_servers, null)
  arp_inspection  = try(each.value.data.arp_inspection, local.defaults.meraki.networks.switch_dhcp_server_policy.arp_inspection, null)
  blocked_servers = try(each.value.data.blocked_servers, local.defaults.meraki.networks.switch_dhcp_server_policy.blocked_servers, null)
  default_policy  = try(each.value.data.default_policy, local.defaults.meraki.networks.switch_dhcp_server_policy.default_policy, null)
}


locals {
  networks_switch_dhcp_server_policy_arp_inspection_trusted_servers = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : [
          for trusted_server in try(network.switch_dhcp_server_policy_arp_inspection_trusted_servers, []) : {
            data       = trusted_server
            network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          }
        ] if try(network.switch_dhcp_server_policy_arp_inspection_trusted_servers, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_dhcp_server_policy_arp_inspection_trusted_servers" "net_switch_dhcp_server_policy_arp_inspection_trusted_servers" {
  for_each          = { for i, v in local.networks_switch_dhcp_server_policy_arp_inspection_trusted_servers : i => v }
  network_id        = each.value.network_id
  ipv4              = try(each.value.data.ipv4, local.defaults.meraki.networks.switch_dhcp_server_policy_arp_inspection_trusted_servers.ipv4, null)
  mac               = try(each.value.data.mac, local.defaults.meraki.networks.switch_dhcp_server_policy_arp_inspection_trusted_servers.mac, null)
  trusted_server_id = try(each.value.data.trusted_server_id, local.defaults.meraki.networks.switch_dhcp_server_policy_arp_inspection_trusted_servers.trusted_server_id, null)
  vlan              = try(each.value.data.vlan, local.defaults.meraki.networks.switch_dhcp_server_policy_arp_inspection_trusted_servers.vlan, null)
}

locals {
  networks_switch_dscp_to_cos_mappings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = network.switch_dscp_to_cos_mappings
        } if try(network.switch_dscp_to_cos_mappings, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_dscp_to_cos_mappings" "net_switch_dscp_to_cos_mappings" {
  for_each   = { for i, v in local.networks_switch_dscp_to_cos_mappings : i => v }
  network_id = each.value.network_id
  mappings   = try(each.value.data.mappings, local.defaults.meraki.networks.switch_dscp_to_cos_mappings.mappings, null)
}



locals {
  networks_switch_link_aggregations = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : [
          for link_aggregation in try(network.switch_link_aggregations, []) : {
            data       = link_aggregation
            network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          }
        ] if try(network.switch_link_aggregations, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_link_aggregations" "net_switch_link_aggregations" {
  for_each   = { for i, v in local.networks_switch_link_aggregations : i => v }
  network_id = each.value.network_id
  # id = try(each.value.data.id, null)
  link_aggregation_id  = try(each.value.data.link_aggregation_id, local.defaults.meraki.networks.switch_link_aggregations.link_aggregation_id, null)
  switch_ports         = try(each.value.data.switch_ports, local.defaults.meraki.networks.switch_link_aggregations.switch_ports, null)
  switch_profile_ports = try(each.value.data.switch_profile_ports, local.defaults.meraki.networks.switch_link_aggregations.switch_profile_ports, null)
}



locals {
  networks_switch_mtu = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = network.switch_mtu
        } if try(network.switch_mtu, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_mtu" "net_switch_mtu" {
  for_each         = { for i, v in local.networks_switch_mtu : i => v }
  network_id       = each.value.network_id
  default_mtu_size = try(each.value.data.default_mtu_size, local.defaults.meraki.networks.switch_mtu.default_mtu_size, null)
  overrides        = try(each.value.data.overrides, local.defaults.meraki.networks.switch_mtu.overrides, null)
}



locals {
  networks_switch_port_schedules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : [
          for port_schedule in try(network.switch_port_schedules, []) : {
            data       = port_schedule
            network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          }
        ] if try(network.switch_port_schedules, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_port_schedules" "net_switch_port_schedules" {
  for_each   = { for i, v in local.networks_switch_port_schedules : i => v }
  network_id = each.value.network_id
  # id = try(each.value.data.id, null)
  name             = try(each.value.data.name, local.defaults.meraki.networks.switch_port_schedules.name, null)
  port_schedule    = try(each.value.data.port_schedule, local.defaults.meraki.networks.switch_port_schedules.port_schedule, null)
  port_schedule_id = try(each.value.data.port_schedule_id, local.defaults.meraki.networks.switch_port_schedules.port_schedule_id, null)
}



locals {
  networks_switch_qos_rules_order = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = network.switch_qos_rules_order
        } if try(network.switch_qos_rules_order, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_qos_rules_order" "net_switch_qos_rules_order" {
  for_each       = { for i, v in local.networks_switch_qos_rules_order : i => v }
  network_id     = each.value.network_id
  dscp           = try(each.value.data.dscp, local.defaults.meraki.networks.switch_qos_rules_order.dscp, null)
  dst_port       = try(each.value.data.dst_port, local.defaults.meraki.networks.switch_qos_rules_order.dst_port, null)
  dst_port_range = try(each.value.data.dst_port_range, local.defaults.meraki.networks.switch_qos_rules_order.dst_port_range, null)
  # id = try(each.value.data.id, local.defaults.meraki.networks.switch_qos_rules_order.id, null)
  protocol       = try(each.value.data.protocol, local.defaults.meraki.networks.switch_qos_rules_order.protocol, null)
  qos_rule_id    = try(each.value.data.qos_rule_id, local.defaults.meraki.networks.switch_qos_rules_order.qos_rule_id, null)
  src_port       = try(each.value.data.src_port, local.defaults.meraki.networks.switch_qos_rules_order.src_port, null)
  src_port_range = try(each.value.data.src_port_range, local.defaults.meraki.networks.switch_qos_rules_order.src_port_range, null)
  vlan           = try(each.value.data.vlan, local.defaults.meraki.networks.switch_qos_rules_order.vlan, null)
}



locals {
  networks_switch_routing_multicast = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = network.switch_routing_multicast
        } if try(network.switch_routing_multicast, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_routing_multicast" "net_switch_routing_multicast" {
  for_each         = { for i, v in local.networks_switch_routing_multicast : i => v }
  network_id       = each.value.network_id
  default_settings = try(each.value.data.default_settings, local.defaults.meraki.networks.switch_routing_multicast.default_settings, null)
  overrides        = try(each.value.data.overrides, local.defaults.meraki.networks.switch_routing_multicast.overrides, null)
}



locals {
  networks_switch_routing_multicast_rendezvous_points = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : [
          for multicast_rendezvous_point in try(network.switch_routing_multicast_rendezvous_points, []) : {
            point_key  = format("%s/%s/%s/multicast_rendezvous_points/%s", domain.name, org.name, network.name, multicast_rendezvous_point.rendezvous_point_name)
            data       = multicast_rendezvous_point
            network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          }
        ] if try(network.switch_routing_multicast_rendezvous_points, null) != null
      ]
    ]
  ])
}

data "meraki_networks_switch_routing_multicast_rendezvous_points" "data_rendezvous_points" {
  for_each   = { for i, v in meraki_networks.networks : i => v }
  network_id = each.value.network_id

  depends_on = [ meraki_networks_switch_stacks_routing_interfaces.net_switch_stacks_routing_interfaces_not_first ]
}

locals {
  rendezvous_map = {
    for net, val in data.meraki_networks_switch_routing_multicast_rendezvous_points.data_rendezvous_points :
    val.network_id => {
      for i in val.items : i.multicast_group => i.rendezvous_point_id
    } if val.items != null
  }
}

resource "meraki_networks_switch_routing_multicast_rendezvous_points" "net_switch_routing_multicast_rendezvous_points" {
  for_each     = { for point in local.networks_switch_routing_multicast_rendezvous_points : point.point_key => point }
  network_id   = each.value.network_id
  interface_ip = try(each.value.data.interface_ip, local.defaults.meraki.networks.switch_routing_multicast_rendezvous_points.interface_ip, null)
  # interface_name = try(each.value.data.interface_name, local.defaults.meraki.networks.switch_routing_multicast_rendezvous_points.interface_name, null)
  multicast_group     = try(each.value.data.multicast_group, local.defaults.meraki.networks.switch_routing_multicast_rendezvous_points.multicast_group, null)
  rendezvous_point_id = try(local.rendezvous_map[each.value.network_id][each.value.data.multicast_group], null)
  # serial = try(each.value.data.serial, null)

  depends_on = [ meraki_networks_switch_stacks_routing_interfaces.net_switch_stacks_routing_interfaces_not_first ]
}

locals {
  networks_switch_routing_ospf = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = network.switch_routing_ospf
        } if try(network.switch_routing_ospf, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_routing_ospf" "net_switch_routing_ospf" {
  for_each                   = { for i, v in local.networks_switch_routing_ospf : i => v }
  network_id                 = each.value.network_id
  areas                      = try(each.value.data.areas, local.defaults.meraki.networks.switch_routing_ospf.areas, null)
  dead_timer_in_seconds      = try(each.value.data.dead_timer_in_seconds, local.defaults.meraki.networks.switch_routing_ospf.dead_timer_in_seconds, null)
  enabled                    = try(each.value.data.enabled, local.defaults.meraki.networks.switch_routing_ospf.enabled, null)
  hello_timer_in_seconds     = try(each.value.data.hello_timer_in_seconds, local.defaults.meraki.networks.switch_routing_ospf.hello_timer_in_seconds, null)
  md5_authentication_enabled = try(each.value.data.md5_authentication_enabled, local.defaults.meraki.networks.switch_routing_ospf.md5_authentication_enabled, null)
  md5_authentication_key     = try(each.value.data.md5_authentication_key, local.defaults.meraki.networks.switch_routing_ospf.md5_authentication_key, null)
  v3                         = try(each.value.data.v3, local.defaults.meraki.networks.switch_routing_ospf.v3, null)
}



locals {
  networks_switch_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = network.switch_settings
        } if try(network.switch_settings, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_settings" "net_switch_settings" {
  for_each               = { for i, v in local.networks_switch_settings : i => v }
  network_id             = each.value.network_id
  mac_blocklist          = try(each.value.data.mac_blocklist, local.defaults.meraki.networks.switch_settings.mac_blocklist, null)
  power_exceptions       = try(each.value.data.power_exceptions, local.defaults.meraki.networks.switch_settings.power_exceptions, null)
  uplink_client_sampling = try(each.value.data.uplink_client_sampling, local.defaults.meraki.networks.switch_settings.uplink_client_sampling, null)
  use_combined_power     = try(each.value.data.use_combined_power, local.defaults.meraki.networks.switch_settings.use_combined_power, null)
  vlan                   = try(each.value.data.vlan, local.defaults.meraki.networks.switch_settings.vlan, null)
}

locals {
  networks_switch_storm_control = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = network.switch_storm_control
        } if try(network.switch_storm_control, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_storm_control" "net_switch_storm_control" {
  for_each                  = { for i, v in local.networks_switch_storm_control : i => v }
  network_id                = each.value.network_id
  broadcast_threshold       = try(each.value.data.broadcast_threshold, local.defaults.meraki.networks.switch_storm_control.broadcast_threshold, null)
  multicast_threshold       = try(each.value.data.multicast_threshold, local.defaults.meraki.networks.switch_storm_control.multicast_threshold, null)
  unknown_unicast_threshold = try(each.value.data.unknown_unicast_threshold, local.defaults.meraki.networks.switch_storm_control.unknown_unicast_threshold, null)
}
data "meraki_networks_switch_stacks" "data_switch_stacks" {
  for_each   = { for i, v in meraki_networks.networks : i => v }
  network_id = each.value.network_id
}

locals {
  switch_stacks_map = {
    for net, val in data.meraki_networks_switch_stacks.data_switch_stacks :
    val.network_id => {
      for i in val.items : i.name => i.id
    } if val.items != null
  }
}

locals {
  networks_switch_stp = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = network.switch_stp
          stp_bridge_priority = [for p in network.switch_stp.stp_bridge_priority : {
            switches     = try(p.switches, null)
            stp_priority = try(p.stp_priority, null)
            stacks       = [for s in try(p.stacks, []) : try(local.switch_stacks_map[meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id][s], null)]
          }]
        } if try(network.switch_stp, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_stp" "net_switch_stp" {
  for_each            = { for i, v in local.networks_switch_stp : i => v }
  network_id          = each.value.network_id
  rstp_enabled        = try(each.value.data.rstp_enabled, local.defaults.meraki.networks.switch_stp.rstp_enabled, null)
  stp_bridge_priority = try(each.value.stp_bridge_priority, null)
}

locals {
  networks_switch_stacks = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : [
          for switch_stack in try(network.switch_stacks, []) : {
            stack_key  = format("%s/%s/%s/stacks/%s", domain.name, org.name, network.name, switch_stack.name)
            data       = switch_stack
            network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          }
        ] if try(network.switch_stacks, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_stacks" "net_switch_stacks" {
  for_each = { for switch_stack in local.networks_switch_stacks : switch_stack.stack_key => switch_stack }
  # id = try(each.value.data.id, null)
  network_id = each.value.network_id
  name       = try(each.value.data.name, local.defaults.meraki.networks.switch_stacks.name, null)
  serials    = try(each.value.data.serials, local.defaults.meraki.networks.switch_stacks.serials, null)
  # switch_stack_id = try(each.value.data.switch_stack_id, null)
}

locals {
  networks_switch_stacks_routing_interfaces_first = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : [
          for switch_stack in try(network.switch_stacks, []) : [
            for interface in try(switch_stack.routing_interfaces, []) : {
              network_id      = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
              switch_stack_id = meraki_networks_switch_stacks.net_switch_stacks["${domain.name}/${org.name}/${network.name}/stacks/${switch_stack.name}"].id
              interface_key   = format("%s/%s/%s/stacks/%s/interfaces/%s", domain.name, org.name, network.name, switch_stack.name, interface.name)
              data            = interface
            } if try(interface.default_gateway, null) != null
          ] if try(switch_stack.routing_interfaces, null) != null
        ] if try(network.switch_stacks, null) != null
      ]
    ]
  ])
  networks_switch_stacks_routing_interfaces_not_first = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : [
          for switch_stack in try(network.switch_stacks, []) : [
            for interface in try(switch_stack.routing_interfaces, []) : {
              network_id      = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
              switch_stack_id = meraki_networks_switch_stacks.net_switch_stacks["${domain.name}/${org.name}/${network.name}/stacks/${switch_stack.name}"].id
              interface_key   = format("%s/%s/%s/stacks/%s/interfaces/%s", domain.name, org.name, network.name, switch_stack.name, interface.name)
              data            = interface
            } if try(interface.default_gateway, null) == null
          ] if try(switch_stack.routing_interfaces, null) != null
        ] if try(network.switch_stacks, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_stacks_routing_interfaces" "net_switch_stacks_routing_interfaces_first" {
  for_each        = { for i, v in local.networks_switch_stacks_routing_interfaces_first : i => v }
  switch_stack_id = each.value.switch_stack_id
  network_id      = each.value.network_id
  default_gateway = try(each.value.data.default_gateway, local.defaults.meraki.networks.switch_stacks_routing_interfaces.default_gateway, null)
  # interface_id = try(each.value.data.interface_id, local.defaults.meraki.networks.switch_stacks_routing_interfaces.interface_id, null)
  interface_ip      = try(each.value.data.interface_ip, local.defaults.meraki.networks.switch_stacks_routing_interfaces.interface_ip, null)
  ipv6              = try(each.value.data.ipv6, local.defaults.meraki.networks.switch_stacks_routing_interfaces.ipv6, null)
  multicast_routing = try(each.value.data.multicast_routing, local.defaults.meraki.networks.switch_stacks_routing_interfaces.multicast_routing, null)
  name              = try(each.value.data.name, local.defaults.meraki.networks.switch_stacks_routing_interfaces.name, null)
  ospf_settings     = try(each.value.data.ospf_settings, local.defaults.meraki.networks.switch_stacks_routing_interfaces.ospf_settings, null)
  # ospf_v3 = try(each.value.data.ospf_v3, local.defaults.meraki.networks.switch_stacks_routing_interfaces.ospf_v3, null)
  subnet  = try(each.value.data.subnet, local.defaults.meraki.networks.switch_stacks_routing_interfaces.subnet, null)
  vlan_id = try(each.value.data.vlan_id, local.defaults.meraki.networks.switch_stacks_routing_interfaces.vlan_id, null)
}

resource "meraki_networks_switch_stacks_routing_interfaces" "net_switch_stacks_routing_interfaces_not_first" {
  for_each        = { for i, v in local.networks_switch_stacks_routing_interfaces_not_first : i => v }
  switch_stack_id = each.value.switch_stack_id
  network_id      = each.value.network_id
  default_gateway = try(each.value.data.default_gateway, local.defaults.meraki.networks.switch_stacks_routing_interfaces.default_gateway, null)
  # interface_id = try(each.value.data.interface_id, local.defaults.meraki.networks.switch_stacks_routing_interfaces.interface_id, null)
  interface_ip      = try(each.value.data.interface_ip, local.defaults.meraki.networks.switch_stacks_routing_interfaces.interface_ip, null)
  ipv6              = try(each.value.data.ipv6, local.defaults.meraki.networks.switch_stacks_routing_interfaces.ipv6, null)
  multicast_routing = try(each.value.data.multicast_routing, local.defaults.meraki.networks.switch_stacks_routing_interfaces.multicast_routing, null)
  name              = try(each.value.data.name, local.defaults.meraki.networks.switch_stacks_routing_interfaces.name, null)
  ospf_settings     = try(each.value.data.ospf_settings, local.defaults.meraki.networks.switch_stacks_routing_interfaces.ospf_settings, null)
  # ospf_v3 = try(each.value.data.ospf_v3, local.defaults.meraki.networks.switch_stacks_routing_interfaces.ospf_v3, null)
  subnet  = try(each.value.data.subnet, local.defaults.meraki.networks.switch_stacks_routing_interfaces.subnet, null)
  vlan_id = try(each.value.data.vlan_id, local.defaults.meraki.networks.switch_stacks_routing_interfaces.vlan_id, null)

  depends_on = [ meraki_networks_switch_stacks_routing_interfaces.net_switch_stacks_routing_interfaces_first ]
}


# locals {
#   networks_switch_stacks_routing_interfaces_dhcp = flatten([
#     for domain in try(local.meraki.domains, []) : [
#       for org in try(domain.organizations, []) : [
#         for network in try(org.networks, []) : [
#           for switch_stack in try(network.switch_stacks, []) : [
#             for interface in try(switch_stack.routing_interfaces, []) : {
#               network_id      = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
#               switch_stack_id = meraki_networks_switch_stacks.net_switch_stacks["${domain.name}/${org.name}/${network.name}/stacks/${switch_stack.name}"].id
#               interface_id    = meraki_networks_switch_stacks_routing_interfaces.net_switch_stacks_routing_interfaces["${domain.name}/${org.name}/${network.name}/stacks/${switch_stack.name}/interfaces/${interface.name}"].interface_id
#               data            = interface.dhcp
#             } if try(interface.dhcp, null) != null
#           ]
#         ]
#       ]
#     ]
#   ])
# }

# resource "meraki_networks_switch_stacks_routing_interfaces_dhcp" "net_switch_stacks_routing_interfaces_dhcp" {
#   for_each               = { for i, v in local.i => v }
#   network_id             = each.value.network_id
#   switch_stack_id        = each.value.switch_stack_id
#   interface_id           = each.value.interface_id
#   boot_file_name         = try(each.value.data.boot_file_name, null)
#   boot_next_server       = try(each.value.data.boot_next_server, null)
#   boot_options_enabled   = try(each.value.data.boot_options_enabled, null)
#   dhcp_lease_time        = try(each.value.data.dhcp_lease_time, null)
#   dhcp_mode              = try(each.value.data.dhcp_mode, null)
#   dhcp_options           = try(each.value.data.dhcp_options, null)
#   dhcp_relay_server_ips  = try(each.value.data.dhcp_relay_server_ips, null)
#   dns_custom_nameservers = try(each.value.data.dns_custom_nameservers, null)
#   dns_nameservers_option = try(each.value.data.dns_nameservers_option, null)
#   fixed_ip_assignments   = try(each.value.data.fixed_ip_assignments, null)
#   reserved_ip_ranges     = try(each.value.data.reserved_ip_ranges, null)
# }

locals {
  networks_switch_stacks_routing_static_routes = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : [
          for switch_stack in try(network.switch_stacks, []) : [
            for static_route in try(switch_stack.routing_static_routes, []) : {
              network_id      = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
              switch_stack_id = meraki_networks_switch_stacks.net_switch_stacks["${domain.name}/${org.name}/${network.name}/stacks/${switch_stack.name}"].id
              data            = static_route
            }
          ] if try(switch_stack.routing_static_routes, null) != null
        ] if try(network.switch_stacks, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_stacks_routing_static_routes" "net_switch_stacks_routing_static_routes" {
  for_each        = { for i, v in local.networks_switch_stacks_routing_static_routes : i => v }
  network_id      = each.value.network_id
  switch_stack_id = each.value.switch_stack_id
  # advertise_via_ospf_enabled = try(each.value.data.advertise_via_ospf_enabled, local.defaults.meraki.networks.switch_stacks_routing_static_routes.advertise_via_ospf_enabled, null)
  name        = try(each.value.data.name, local.defaults.meraki.networks.switch_stacks_routing_static_routes.name, null)
  next_hop_ip = try(each.value.data.next_hop_ip, local.defaults.meraki.networks.switch_stacks_routing_static_routes.next_hop_ip, null)
  # prefer_over_ospf_routes_enabled = try(each.value.data.prefer_over_ospf_routes_enabled, local.defaults.meraki.networks.switch_stacks_routing_static_routes.prefer_over_ospf_routes_enabled, null)
  subnet = try(each.value.data.subnet, local.defaults.meraki.networks.switch_stacks_routing_static_routes.subnet, null)
  # static_route_id                 = try(each.value.data.static_route_id, null)

  depends_on = [ meraki_networks_switch_stacks_routing_interfaces.net_switch_stacks_routing_interfaces_not_first ]
}



