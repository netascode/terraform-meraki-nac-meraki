locals {
  networks_group_policies = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : [
          for group_policy in try(network.group_policies, []) : {
            network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
            name       = group_policy.name
          }
        ]
      ]
    ]
  ])
}

resource "meraki_networks_group_policies" "net_group_policies" {
  for_each   = { for i, v in local.networks_group_policies : i => v }
  network_id = each.value.network_id
  name       = each.value.name
}

locals {
  networks_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          settings   = try(network.settings, {})
        }
      ]
    ]
  ])
}

resource "meraki_networks_settings" "net_settings" {
  for_each                  = { for settings in local.networks_settings : settings.network_id => settings.settings }
  network_id                = each.key
  local_status_page_enabled = try(each.value.local_status_page_enabled, false)
}


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
  for_each   = { for data in local.networks_switch_access_control_lists : data.network_id => data.data }
  network_id = each.key
  rules      = try(each.value.rules, null)
  # rules_response = try(each.value.rules_response, null)
}


locals {
  networks_switch_access_policies = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = network.switch_access_policies
        } if try(network.switch_access_policies, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_access_policies" "net_switch_access_policies" {
  for_each             = { for data in local.networks_switch_access_policies : data.network_id => data.data }
  network_id           = each.key
  access_policy_number = try(each.value.access_policy_number, null)
  access_policy_type   = try(each.value.access_policy_type, null)
  # counts = try(each.value.counts, null)
  dot1x                     = try(each.value.dot1x, null)
  guest_port_bouncing       = try(each.value.guest_port_bouncing, null)
  guest_vlan_id             = try(each.value.guest_vlan_id, null)
  host_mode                 = try(each.value.host_mode, null)
  increase_access_speed     = try(each.value.increase_access_speed, null)
  name                      = try(each.value.name, null)
  radius                    = try(each.value.radius, null)
  radius_accounting_enabled = try(each.value.radius_accounting_enabled, null)
  radius_accounting_servers = try(each.value.radius_accounting_servers, null)
  # radius_accounting_servers_response = try(each.value.radius_accounting_servers_response, null)
  radius_coa_support_enabled = try(each.value.radius_coa_support_enabled, null)
  radius_group_attribute     = try(each.value.radius_group_attribute, null)
  radius_servers             = try(each.value.radius_servers, null)
  # radius_servers_response = try(each.value.radius_servers_response, null)
  radius_testing_enabled             = try(each.value.radius_testing_enabled, null)
  url_redirect_walled_garden_enabled = try(each.value.url_redirect_walled_garden_enabled, null)
  url_redirect_walled_garden_ranges  = try(each.value.url_redirect_walled_garden_ranges, null)
  voice_vlan_clients                 = try(each.value.voice_vlan_clients, null)
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
  for_each   = { for data in local.networks_switch_alternate_management_interface : data.network_id => data.data }
  network_id = each.key
  enabled    = try(each.value.enabled, null)
  protocols  = try(each.value.protocols, null)
  switches   = try(each.value.switches, null)
  vlan_id    = try(each.value.vlan_id, null)
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
  for_each        = { for data in local.networks_switch_dhcp_server_policy : data.network_id => data.data }
  network_id      = each.key
  alerts          = try(each.value.alerts, null)
  allowed_servers = try(each.value.allowed_servers, null)
  arp_inspection  = try(each.value.arp_inspection, null)
  blocked_servers = try(each.value.blocked_servers, null)
  default_policy  = try(each.value.default_policy, null)
}


# locals {
#   networks_switch_dhcp_server_policy_arp_inspection_trusted_servers = flatten([
#     for domain in try(local.meraki.domains, []) : [
#       for org in try(domain.organizations, []) : [
#         for network in try(org.networks, []) : {
#           network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
#           data       = network.switch_dhcp_server_policy_arp_inspection_trusted_servers
#         } if try(network.switch_dhcp_server_policy_arp_inspection_trusted_servers, null) != null
#       ]
#     ]
#   ])
# }

# resource "meraki_networks_switch_dhcp_server_policy_arp_inspection_trusted_servers" "net_switch_dhcp_server_policy_arp_inspection_trusted_servers" {
#   for_each          = { for data in local.networks_switch_dhcp_server_policy_arp_inspection_trusted_servers : data.network_id => data.data }
#   network_id        = each.key
#   ipv4              = try(each.value.ipv4, null)
#   mac               = try(each.value.mac, null)
#   trusted_server_id = try(each.value.trusted_server_id, null)
#   vlan              = try(each.value.vlan, null)
# }



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
  for_each   = { for data in local.networks_switch_dscp_to_cos_mappings : data.network_id => data.data }
  network_id = each.key
  mappings   = try(each.value.mappings, null)
}



locals {
  networks_switch_link_aggregations = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = network.switch_link_aggregations
        } if try(network.switch_link_aggregations, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_link_aggregations" "net_switch_link_aggregations" {
  for_each   = { for data in local.networks_switch_link_aggregations : data.network_id => data.data }
  network_id = each.key
  # id = try(each.value.id, null)
  link_aggregation_id  = try(each.value.link_aggregation_id, null)
  switch_ports         = try(each.value.switch_ports, null)
  switch_profile_ports = try(each.value.switch_profile_ports, null)
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
  for_each         = { for data in local.networks_switch_mtu : data.network_id => data.data }
  network_id       = each.key
  default_mtu_size = try(each.value.default_mtu_size, null)
  overrides        = try(each.value.overrides, null)
}



locals {
  networks_switch_port_schedules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = network.switch_port_schedules
        } if try(network.switch_port_schedules, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_port_schedules" "net_switch_port_schedules" {
  for_each   = { for data in local.networks_switch_port_schedules : data.network_id => data.data }
  network_id = each.key
  # id = try(each.value.id, null)
  name             = try(each.value.name, null)
  port_schedule    = try(each.value.port_schedule, null)
  port_schedule_id = try(each.value.port_schedule_id, null)
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
  for_each       = { for data in local.networks_switch_qos_rules_order : data.network_id => data.data }
  network_id     = each.key
  dscp           = try(each.value.dscp, null)
  dst_port       = try(each.value.dst_port, null)
  dst_port_range = try(each.value.dst_port_range, null)
  # id = try(each.value.id, null)
  protocol       = try(each.value.protocol, null)
  qos_rule_id    = try(each.value.qos_rule_id, null)
  src_port       = try(each.value.src_port, null)
  src_port_range = try(each.value.src_port_range, null)
  vlan           = try(each.value.vlan, null)
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
  for_each         = { for data in local.networks_switch_routing_multicast : data.network_id => data.data }
  network_id       = each.key
  default_settings = try(each.value.default_settings, null)
  overrides        = try(each.value.overrides, null)
}



locals {
  networks_switch_routing_multicast_rendezvous_points = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = network.switch_routing_multicast_rendezvous_points
        } if try(network.switch_routing_multicast_rendezvous_points, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_routing_multicast_rendezvous_points" "net_switch_routing_multicast_rendezvous_points" {
  for_each     = { for data in local.networks_switch_routing_multicast_rendezvous_points : data.network_id => data.data }
  network_id   = each.key
  interface_ip = try(each.value.interface_ip, null)
  # interface_name = try(each.value.interface_name, null)
  multicast_group     = try(each.value.multicast_group, null)
  rendezvous_point_id = try(each.value.rendezvous_point_id, null)
  # serial = try(each.value.serial, null)
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
  for_each                   = { for data in local.networks_switch_routing_ospf : data.network_id => data.data }
  network_id                 = each.key
  areas                      = try(each.value.areas, null)
  dead_timer_in_seconds      = try(each.value.dead_timer_in_seconds, null)
  enabled                    = try(each.value.enabled, null)
  hello_timer_in_seconds     = try(each.value.hello_timer_in_seconds, null)
  md5_authentication_enabled = try(each.value.md5_authentication_enabled, null)
  md5_authentication_key     = try(each.value.md5_authentication_key, null)
  v3                         = try(each.value.v3, null)
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
  for_each               = { for data in local.networks_switch_settings : data.network_id => data.data }
  network_id             = each.key
  mac_blocklist          = try(each.value.mac_blocklist, null)
  power_exceptions       = try(each.value.power_exceptions, null)
  uplink_client_sampling = try(each.value.uplink_client_sampling, null)
  use_combined_power     = try(each.value.use_combined_power, null)
  vlan                   = try(each.value.vlan, null)
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
  for_each                  = { for data in local.networks_switch_storm_control : data.network_id => data.data }
  network_id                = each.key
  broadcast_threshold       = try(each.value.broadcast_threshold, null)
  multicast_threshold       = try(each.value.multicast_threshold, null)
  unknown_unicast_threshold = try(each.value.unknown_unicast_threshold, null)
}



locals {
  networks_switch_stp = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = network.switch_stp
        } if try(network.switch_stp, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_stp" "net_switch_stp" {
  for_each            = { for data in local.networks_switch_stp : data.network_id => data.data }
  network_id          = each.key
  rstp_enabled        = try(each.value.rstp_enabled, null)
  stp_bridge_priority = try(each.value.stp_bridge_priority, null)
  # stp_bridge_priority_response = try(each.value.stp_bridge_priority_response, null)
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
        ]
      ]
    ]
  ])
}

resource "meraki_networks_switch_stacks" "net_switch_stacks" {
  for_each = { for switch_stack in local.networks_switch_stacks : switch_stack.stack_key => switch_stack }
  # id = try(each.value.id, null)
  network_id = each.value.network_id
  name       = try(each.value.data.name, null)
  serials    = try(each.value.data.serials, null)
  # switch_stack_id = try(each.value.data.switch_stack_id, null)
}

locals {
  networks_switch_stacks_routing_interfaces = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : [
          for switch_stack in try(network.switch_stacks, []) : [
            for interface in try(switch_stack.routing_interfaces, []) : {
              network_id      = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
              switch_stack_id = meraki_networks_switch_stacks.net_switch_stacks["${domain.name}/${org.name}/${network.name}/stacks/${switch_stack.name}"].id
              interface_key   = format("%s/%s/%s/stacks/%s/interfaces/%s", domain.name, org.name, network.name, switch_stack.name, interface.name)
              data            = interface
            }
          ]
        ]
      ]
    ]
  ])
}

resource "meraki_networks_switch_stacks_routing_interfaces" "net_switch_stacks_routing_interfaces" {
  for_each        = { for data in local.networks_switch_stacks_routing_interfaces : data.interface_key => data }
  switch_stack_id = each.value.switch_stack_id
  network_id      = each.value.network_id
  # default_gateway = try(each.value.data.default_gateway, null)
  # interface_id      = try(each.value.data.interface_id, null)
  interface_ip      = try(each.value.data.interface_ip, null)
  ipv6              = try(each.value.data.ipv6, null)
  multicast_routing = try(each.value.data.multicast_routing, null)
  name              = try(each.value.data.name, null)
  ospf_settings     = try(each.value.data.ospf_settings, null)
  # ospf_v3           = try(each.value.data.ospf_v3, null)
  subnet  = try(each.value.data.subnet, null)
  vlan_id = try(each.value.data.vlan_id, null)
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
#   for_each               = { for data in local.networks_switch_stacks_routing_interfaces_dhcp : data.interface_id => data }
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
          ]
        ]
      ]
    ]
  ])
}

resource "meraki_networks_switch_stacks_routing_static_routes" "net_switch_stacks_routing_static_routes" {
  for_each                        = { for data in local.networks_switch_stacks_routing_static_routes : data.switch_stack_id => data }
  network_id                      = each.value.network_id
  switch_stack_id                 = each.value.switch_stack_id
  # advertise_via_ospf_enabled      = try(each.value.data.advertise_via_ospf_enabled, null)
  name                            = try(each.value.data.name, null)
  next_hop_ip                     = try(each.value.data.next_hop_ip, null)
  # prefer_over_ospf_routes_enabled = try(each.value.data.prefer_over_ospf_routes_enabled, null)
  subnet                          = try(each.value.data.subnet, null)
  # static_route_id                 = try(each.value.static_route_id, null)
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
  for_each   = { for data in local.networks_syslog_servers : data.network_id => data.data }
  network_id = each.key
  servers    = try(each.value.servers, null)
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
        ]
      ]
    ]
  ])
}

resource "meraki_networks_vlan_profiles" "net_vlan_profiles" {
  for_each   = { for data in local.networks_vlan_profiles : data.network_id => data.data }
  network_id = each.key
  iname      = try(each.value.iname, null)
  # is_default  = try(each.value.is_default, null)
  name        = try(each.value.name, null)
  vlan_groups = try(each.value.vlan_groups, null)
  vlan_names  = try(each.value.vlan_names, null)
}

locals {
  networks_wireless_rf_profiles = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : [
          for wireless_rf_profile in try(network.wireless_rf_profiles, []) : {
            network_id     = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
            rf_profile_key = format("%s/%s/%s/wireless_rf_profiles/%s", domain.name, org.name, network.name, wireless_rf_profile.name)
            data           = wireless_rf_profile
          }
        ]
      ]
    ]
  ])
}

resource "meraki_networks_wireless_rf_profiles" "net_wireless_rf_profiles" {
  for_each                 = { for data in local.networks_wireless_rf_profiles : data.rf_profile_key => data }
  network_id               = each.value.network_id
  ap_band_settings         = try(each.value.data.ap_band_settings, null)
  band_selection_type      = try(each.value.data.band_selection_type, null)
  client_balancing_enabled = try(each.value.data.client_balancing_enabled, null)
  five_ghz_settings        = try(each.value.data.five_ghz_settings, null)
  flex_radios              = try(each.value.data.flex_radios, null)
  min_bitrate_type         = try(each.value.data.min_bitrate_type, null)
  name                     = try(each.value.data.name, null)
  per_ssid_settings        = try(each.value.data.per_ssid_settings, null)
  rf_profile_id            = try(each.value.data.rf_profile_id, null)
  six_ghz_settings         = try(each.value.data.six_ghz_settings, null)
  transmission             = try(each.value.data.transmission, null)
  two_four_ghz_settings    = try(each.value.data.two_four_ghz_settings, null)
}

locals {
  networks_wireless_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = network.wireless_settings
        } if try(network.wireless_settings, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_wireless_settings" "net_wireless_settings" {
  for_each                   = { for data in local.networks_wireless_settings : data.network_id => data.data }
  network_id                 = each.key
  ipv6_bridge_enabled        = try(each.value.ipv6_bridge_enabled, null)
  led_lights_on              = try(each.value.led_lights_on, null)
  location_analytics_enabled = try(each.value.location_analytics_enabled, null)
  meshing_enabled            = try(each.value.meshing_enabled, null)
  named_vlans                = try(each.value.named_vlans, null)
  # regulatory_domain          = try(each.value.regulatory_domain, null)
  upgradestrategy = try(each.value.upgradestrategy, null)
}

locals {
  networks_wireless_ssids = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : [
          for wireless_ssid in try(network.wireless_ssids, []) : {
            wireless_ssid_key = format("%s/%s/%s/wireless_ssids/%s", domain.name, org.name, network.name, wireless_ssid.name)
            data              = wireless_ssid
            network_id        = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          }
        ]
      ]
    ]
  ])
}

resource "meraki_networks_wireless_ssids" "net_wireless_ssids" {
  for_each                             = { for data in local.networks_wireless_ssids : data.wireless_ssid_key => data }
  network_id                           = each.value.network_id
  number                               = each.value.data.number
  active_directory                     = try(each.value.data.active_directory, null)
  # admin_splash_url                     = try(each.value.data.admin_splash_url, null)
  adult_content_filtering_enabled      = try(each.value.data.adult_content_filtering_enabled, null)
  ap_tags_and_vlan_ids                 = try(each.value.data.ap_tags_and_vlan_ids, null)
  auth_mode                            = try(each.value.data.auth_mode, null)
  availability_tags                    = try(each.value.data.availability_tags, null)
  available_on_all_aps                 = try(each.value.data.available_on_all_aps, null)
  band_selection                       = try(each.value.data.band_selection, null)
  concentrator_network_id              = try(each.value.data.concentrator_network_id, null)
  default_vlan_id                      = try(each.value.data.default_vlan_id, null)
  disassociate_clients_on_vpn_failover = try(each.value.data.disassociate_clients_on_vpn_failover, null)
  dns_rewrite                          = try(each.value.data.dns_rewrite, null)
  dot11r                               = try(each.value.data.dot11r, null)
  dot11w                               = try(each.value.data.dot11w, null)
  enabled                              = try(each.value.data.enabled, null)
  encryption_mode                      = try(each.value.data.encryption_mode, null)
  enterprise_admin_access              = try(each.value.data.enterprise_admin_access, null)
  gre                                  = try(each.value.data.gre, null)
  ip_assignment_mode                   = try(each.value.data.ip_assignment_mode, null)
  lan_isolation_enabled                = try(each.value.data.lan_isolation_enabled, null)
  ldap                                 = try(each.value.data.ldap, null)
  # local_auth                           = try(each.value.data.local_auth, null)
  local_radius                         = try(each.value.data.local_radius, null)
  mandatory_dhcp_enabled               = try(each.value.data.mandatory_dhcp_enabled, null)
  min_bitrate                          = try(each.value.data.min_bitrate, null)
  name                                 = try(each.value.data.name, null)
  named_vlans                          = try(each.value.data.named_vlans, null)
  oauth                                = try(each.value.data.oauth, null)
  per_client_bandwidth_limit_down      = try(each.value.data.per_client_bandwidth_limit_down, null)
  per_client_bandwidth_limit_up        = try(each.value.data.per_client_bandwidth_limit_up, null)
  per_ssid_bandwidth_limit_down        = try(each.value.data.per_ssid_bandwidth_limit_down, null)
  per_ssid_bandwidth_limit_up          = try(each.value.data.per_ssid_bandwidth_limit_up, null)
  psk                                  = try(each.value.data.psk, null)
  radius_accounting_enabled            = try(each.value.data.radius_accounting_enabled, null)
  radius_accounting_interim_interval   = try(each.value.data.radius_accounting_interim_interval, null)
  radius_accounting_servers            = try(each.value.data.radius_accounting_servers, null)
  radius_attribute_for_group_policies  = try(each.value.data.radius_attribute_for_group_policies, null)
  radius_authentication_nas_id         = try(each.value.data.radius_authentication_nas_id, null)
  radius_called_station_id             = try(each.value.data.radius_called_station_id, null)
  radius_coa_enabled                   = try(each.value.data.radius_coa_enabled, null)
  # radius_enabled                       = try(each.value.data.radius_enabled, null)
  radius_failover_policy               = try(each.value.data.radius_failover_policy, null)
  radius_fallback_enabled              = try(each.value.data.radius_fallback_enabled, null)
  radius_guest_vlan_enabled            = try(each.value.data.radius_guest_vlan_enabled, null)
  radius_guest_vlan_id                 = try(each.value.data.radius_guest_vlan_id, null)
  radius_load_balancing_policy         = try(each.value.data.radius_load_balancing_policy, null)
  radius_override                      = try(each.value.data.radius_override, null)
  radius_proxy_enabled                 = try(each.value.data.radius_proxy_enabled, null)
  radius_server_attempts_limit         = try(each.value.data.radius_server_attempts_limit, null)
  radius_server_timeout                = try(each.value.data.radius_server_timeout, null)
  radius_servers                       = try(each.value.data.radius_servers, null)
  # radius_servers_response              = try(each.value.data.radius_servers_response, null)
  radius_testing_enabled               = try(each.value.data.radius_testing_enabled, null)
  secondary_concentrator_network_id    = try(each.value.data.secondary_concentrator_network_id, null)
  speed_burst                          = try(each.value.data.speed_burst, null)
  splash_guest_sponsor_domains         = try(each.value.data.splash_guest_sponsor_domains, null)
  splash_page                          = try(each.value.data.splash_page, null)
  # splash_timeout                       = try(each.value.data.splash_timeout, null)
  # ssid_admin_accessible                = try(each.value.data.ssid_admin_accessible, null)
  use_vlan_tagging                     = try(each.value.data.use_vlan_tagging, null)
  visible                              = try(each.value.data.visible, null)
  vlan_id                              = try(each.value.data.vlan_id, null)
  walled_garden_enabled                = try(each.value.data.walled_garden_enabled, null)
  walled_garden_ranges                 = try(each.value.data.walled_garden_ranges, null)
  wpa_encryption_mode                  = try(each.value.data.wpa_encryption_mode, null)
}
