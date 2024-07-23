locals {
  networks_group_policies = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : [
          for group_policy in try(network.group_policies, []) : {
            network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
            name       = try(group_policy.name, null)
            scheduling = try(group_policy.scheduling, null)
            bandwidth   = try(group_policy.bandwidth, null)
            firewall_and_traffic_shaping = try(group_policy.firewall_and_traffic_shaping, null)
            content_filtering = try(group_policy.content_filtering, null)
            splash_auth_settings = try(group_policy.splash_auth_settings, null)
            vlan_tagging = try(group_policy.vlan_tagging, null)
            bonjour_forwarding = try(group_policy.bonjour_forwarding, null)
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
  scheduling = each.value.scheduling
  bandwidth   = each.value.bandwidth
  firewall_and_traffic_shaping = each.value.firewall_and_traffic_shaping
  content_filtering = each.value.content_filtering
  splash_auth_settings = each.value.splash_auth_settings
  vlan_tagging = each.value.vlan_tagging
  bonjour_forwarding = each.value.bonjour_forwarding
}

# locals {
#   networks_settings = flatten([
#     for domain in try(local.meraki.domains, []) : [
#       for org in try(domain.organizations, []) : [
#         for network in try(org.networks, []) : {
#           network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
#           data   = try(network.settings, {})
#         }
#       ]
#     ]
#   ])
# }

# resource "meraki_networks_settings" "net_settings" {
#   for_each                  = { for i, v in local.networks_settings : i => v }
#   network_id                = each.value.network_id
#   local_status_page_enabled = try(each.value.data.local_status_page_enabled, false)
# }


# locals {
#   networks_switch_access_control_lists = flatten([
#     for domain in try(local.meraki.domains, []) : [
#       for org in try(domain.organizations, []) : [
#         for network in try(org.networks, []) : {
#           network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
#           data       = network.switch_access_control_lists
#         } if try(network.switch_access_control_lists, null) != null
#       ]
#     ]
#   ])
# }

# resource "meraki_networks_switch_access_control_lists" "net_switch_access_control_lists" {
#   for_each   = { for i, v in local.networks_switch_access_control_lists : i => v }
#   network_id = each.value.network_id
#   rules      = try(each.value.data.rules, null)

#   # rules_response = try(each.value.data.rules_response, null)
# }


# locals {
#   networks_switch_access_policies = flatten([
#     for domain in try(local.meraki.domains, []) : [
#       for org in try(domain.organizations, []) : [
#         for network in try(org.networks, []) : {
#           network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
#           data       = network.switch_access_policies
#         } if try(network.switch_access_policies, null) != null
#       ]
#     ]
#   ])
# }

# resource "meraki_networks_switch_access_policies" "net_switch_access_policies" {
#   for_each             = { for i, v in local.networks_switch_access_policies : i => v }
#   network_id           = each.value.network_id
#   access_policy_number = try(each.value.data.access_policy_number, null)
#   access_policy_type   = try(each.value.data.access_policy_type, null)
#   # counts = try(each.value.data.counts, null)
#   dot1x                     = try(each.value.data.dot1x, null)
#   guest_port_bouncing       = try(each.value.data.guest_port_bouncing, null)
#   guest_vlan_id             = try(each.value.data.guest_vlan_id, null)
#   host_mode                 = try(each.value.data.host_mode, null)
#   increase_access_speed     = try(each.value.data.increase_access_speed, null)
#   name                      = try(each.value.data.name, null)
#   radius                    = try(each.value.data.radius, null)
#   radius_accounting_enabled = try(each.value.data.radius_accounting_enabled, null)
#   radius_accounting_servers = try(each.value.data.radius_accounting_servers, null)
#   # radius_accounting_servers_response = try(each.value.data.radius_accounting_servers_response, null)
#   radius_coa_support_enabled = try(each.value.data.radius_coa_support_enabled, null)
#   radius_group_attribute     = try(each.value.data.radius_group_attribute, null)
#   radius_servers             = try(each.value.data.radius_servers, null)
#   # radius_servers_response = try(each.value.data.radius_servers_response, null)
#   radius_testing_enabled             = try(each.value.data.radius_testing_enabled, null)
#   url_redirect_walled_garden_enabled = try(each.value.data.url_redirect_walled_garden_enabled, null)
#   url_redirect_walled_garden_ranges  = try(each.value.data.url_redirect_walled_garden_ranges, null)
#   voice_vlan_clients                 = try(each.value.data.voice_vlan_clients, null)
# }



# locals {
#   networks_switch_alternate_management_interface = flatten([
#     for domain in try(local.meraki.domains, []) : [
#       for org in try(domain.organizations, []) : [
#         for network in try(org.networks, []) : {
#           network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
#           data       = network.switch_alternate_management_interface
#         } if try(network.switch_alternate_management_interface, null) != null
#       ]
#     ]
#   ])
# }

# resource "meraki_networks_switch_alternate_management_interface" "net_switch_alternate_management_interface" {
#   for_each   = { for i, v in local.networks_switch_alternate_management_interface : i => v }
#   network_id = each.value.network_id
#   enabled    = try(each.value.data.enabled, null)
#   protocols  = try(each.value.data.protocols, null)
#   switches   = try(each.value.data.switches, null)
#   vlan_id    = try(each.value.data.vlan_id, null)
# }



# locals {
#   networks_switch_dhcp_server_policy = flatten([
#     for domain in try(local.meraki.domains, []) : [
#       for org in try(domain.organizations, []) : [
#         for network in try(org.networks, []) : {
#           network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
#           data       = network.switch_dhcp_server_policy
#         } if try(network.switch_dhcp_server_policy, null) != null
#       ]
#     ]
#   ])
# }

# resource "meraki_networks_switch_dhcp_server_policy" "net_switch_dhcp_server_policy" {
#   for_each        = { for i, v in local.networks_switch_dhcp_server_policy : i => v }
#   network_id      = each.value.network_id
#   alerts          = try(each.value.data.alerts, null)
#   allowed_servers = try(each.value.data.allowed_servers, null)
#   arp_inspection  = try(each.value.data.arp_inspection, null)
#   blocked_servers = try(each.value.data.blocked_servers, null)
#   default_policy  = try(each.value.data.default_policy, null)
# }


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
#   for_each          = { for i, v in local.networks_switch_dhcp_server_policy_arp_inspection_trusted_servers : i => v }
#   network_id        = each.value.network_id
#   ipv4              = try(each.value.data.ipv4, null)
#   mac               = try(each.value.data.mac, null)
#   trusted_server_id = try(each.value.data.trusted_server_id, null)
#   vlan              = try(each.value.data.vlan, null)
# }



# locals {
#   networks_switch_dscp_to_cos_mappings = flatten([
#     for domain in try(local.meraki.domains, []) : [
#       for org in try(domain.organizations, []) : [
#         for network in try(org.networks, []) : {
#           network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
#           data       = network.switch_dscp_to_cos_mappings
#         } if try(network.switch_dscp_to_cos_mappings, null) != null
#       ]
#     ]
#   ])
# }

# resource "meraki_networks_switch_dscp_to_cos_mappings" "net_switch_dscp_to_cos_mappings" {
#   for_each   = { for i, v in local.networks_switch_dscp_to_cos_mappings : i => v }
#   network_id = each.value.network_id
#   mappings   = try(each.value.data.mappings, null)
# }



# locals {
#   networks_switch_link_aggregations = flatten([
#     for domain in try(local.meraki.domains, []) : [
#       for org in try(domain.organizations, []) : [
#         for network in try(org.networks, []) : {
#           network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
#           data       = network.switch_link_aggregations
#         } if try(network.switch_link_aggregations, null) != null
#       ]
#     ]
#   ])
# }

# resource "meraki_networks_switch_link_aggregations" "net_switch_link_aggregations" {
#   for_each   = { for i, v in local.networks_switch_link_aggregations : i => v }
#   network_id = each.value.network_id
#   # id = try(each.value.data.id, null)
#   link_aggregation_id  = try(each.value.data.link_aggregation_id, null)
#   switch_ports         = try(each.value.data.switch_ports, null)
#   switch_profile_ports = try(each.value.data.switch_profile_ports, null)
# }



# locals {
#   networks_switch_mtu = flatten([
#     for domain in try(local.meraki.domains, []) : [
#       for org in try(domain.organizations, []) : [
#         for network in try(org.networks, []) : {
#           network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
#           data       = network.switch_mtu
#         } if try(network.switch_mtu, null) != null
#       ]
#     ]
#   ])
# }

# resource "meraki_networks_switch_mtu" "net_switch_mtu" {
#   for_each         = { for i, v in local.networks_switch_mtu : i => v }
#   network_id       = each.value.network_id
#   default_mtu_size = try(each.value.data.default_mtu_size, null)
#   overrides        = try(each.value.data.overrides, null)
# }



# locals {
#   networks_switch_port_schedules = flatten([
#     for domain in try(local.meraki.domains, []) : [
#       for org in try(domain.organizations, []) : [
#         for network in try(org.networks, []) : {
#           network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
#           data       = network.switch_port_schedules
#         } if try(network.switch_port_schedules, null) != null
#       ]
#     ]
#   ])
# }

# resource "meraki_networks_switch_port_schedules" "net_switch_port_schedules" {
#   for_each   = { for i, v in local.networks_switch_port_schedules : i => v }
#   network_id = each.value.network_id
#   # id = try(each.value.data.id, null)
#   name             = try(each.value.data.name, null)
#   port_schedule    = try(each.value.data.port_schedule, null)
#   port_schedule_id = try(each.value.data.port_schedule_id, null)
# }



# locals {
#   networks_switch_qos_rules_order = flatten([
#     for domain in try(local.meraki.domains, []) : [
#       for org in try(domain.organizations, []) : [
#         for network in try(org.networks, []) : {
#           network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
#           data       = network.switch_qos_rules_order
#         } if try(network.switch_qos_rules_order, null) != null
#       ]
#     ]
#   ])
# }

# resource "meraki_networks_switch_qos_rules_order" "net_switch_qos_rules_order" {
#   for_each       = { for i, v in local.networks_switch_qos_rules_order : i => v }
#   network_id     = each.value.network_id
#   dscp           = try(each.value.data.dscp, null)
#   dst_port       = try(each.value.data.dst_port, null)
#   dst_port_range = try(each.value.data.dst_port_range, null)
#   # id = try(each.value.data.id, null)
#   protocol       = try(each.value.data.protocol, null)
#   qos_rule_id    = try(each.value.data.qos_rule_id, null)
#   src_port       = try(each.value.data.src_port, null)
#   src_port_range = try(each.value.data.src_port_range, null)
#   vlan           = try(each.value.data.vlan, null)
# }



# locals {
#   networks_switch_routing_multicast = flatten([
#     for domain in try(local.meraki.domains, []) : [
#       for org in try(domain.organizations, []) : [
#         for network in try(org.networks, []) : {
#           network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
#           data       = network.switch_routing_multicast
#         } if try(network.switch_routing_multicast, null) != null
#       ]
#     ]
#   ])
# }

# resource "meraki_networks_switch_routing_multicast" "net_switch_routing_multicast" {
#   for_each         = { for i, v in local.networks_switch_routing_multicast : i => v }
#   network_id       = each.value.network_id
#   default_settings = try(each.value.data.default_settings, null)
#   overrides        = try(each.value.data.overrides, null)
# }



# locals {
#   networks_switch_routing_multicast_rendezvous_points = flatten([
#     for domain in try(local.meraki.domains, []) : [
#       for org in try(domain.organizations, []) : [
#         for network in try(org.networks, []) : {
#           network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
#           data       = network.switch_routing_multicast_rendezvous_points
#         } if try(network.switch_routing_multicast_rendezvous_points, null) != null
#       ]
#     ]
#   ])
# }

# resource "meraki_networks_switch_routing_multicast_rendezvous_points" "net_switch_routing_multicast_rendezvous_points" {
#   for_each     = { for i, v in local.networks_switch_routing_multicast_rendezvous_points : i => v }
#   network_id   = each.value.network_id
#   interface_ip = try(each.value.data.interface_ip, null)
#   # interface_name = try(each.value.data.interface_name, null)
#   multicast_group     = try(each.value.data.multicast_group, null)
#   rendezvous_point_id = try(each.value.data.rendezvous_point_id, null)
#   # serial = try(each.value.data.serial, null)
# }



# # locals {
# #   networks_switch_routing_ospf = flatten([
# #     for domain in try(local.meraki.domains, []) : [
# #       for org in try(domain.organizations, []) : [
# #         for network in try(org.networks, []) : {
# #           network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
# #           data       = network.switch_routing_ospf
# #         } if try(network.switch_routing_ospf, null) != null
# #       ]
# #     ]
# #   ])
# # }

# # resource "meraki_networks_switch_routing_ospf" "net_switch_routing_ospf" {
# #   for_each                   = { for i, v in local.networks_switch_routing_ospf : i => v }
# #   network_id                 = each.value.network_id
# #   areas                      = try(each.value.data.areas, null)
# #   dead_timer_in_seconds      = try(each.value.data.dead_timer_in_seconds, null)
# #   enabled                    = try(each.value.data.enabled, null)
# #   hello_timer_in_seconds     = try(each.value.data.hello_timer_in_seconds, null)
# #   md5_authentication_enabled = try(each.value.data.md5_authentication_enabled, null)
# #   md5_authentication_key     = try(each.value.data.md5_authentication_key, null)
# #   v3                         = try(each.value.data.v3, null)
# # }



# locals {
#   networks_switch_settings = flatten([
#     for domain in try(local.meraki.domains, []) : [
#       for org in try(domain.organizations, []) : [
#         for network in try(org.networks, []) : {
#           network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
#           data       = network.switch_settings
#         } if try(network.switch_settings, null) != null
#       ]
#     ]
#   ])
# }

# resource "meraki_networks_switch_settings" "net_switch_settings" {
#   for_each               = { for i, v in local.networks_switch_settings : i => v }
#   network_id             = each.value.network_id
#   mac_blocklist          = try(each.value.data.mac_blocklist, null)
#   power_exceptions       = try(each.value.data.power_exceptions, null)
#   uplink_client_sampling = try(each.value.data.uplink_client_sampling, null)
#   use_combined_power     = try(each.value.data.use_combined_power, null)
#   vlan                   = try(each.value.data.vlan, null)
# }

# locals {
#   networks_switch_storm_control = flatten([
#     for domain in try(local.meraki.domains, []) : [
#       for org in try(domain.organizations, []) : [
#         for network in try(org.networks, []) : {
#           network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
#           data       = network.switch_storm_control
#         } if try(network.switch_storm_control, null) != null
#       ]
#     ]
#   ])
# }

# resource "meraki_networks_switch_storm_control" "net_switch_storm_control" {
#   for_each                  = { for i, v in local.networks_switch_storm_control : i => v }
#   network_id                = each.value.network_id
#   broadcast_threshold       = try(each.value.data.broadcast_threshold, null)
#   multicast_threshold       = try(each.value.data.multicast_threshold, null)
#   unknown_unicast_threshold = try(each.value.data.unknown_unicast_threshold, null)
# }



# locals {
#   networks_switch_stp = flatten([
#     for domain in try(local.meraki.domains, []) : [
#       for org in try(domain.organizations, []) : [
#         for network in try(org.networks, []) : {
#           network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
#           data       = network.switch_stp
#         } if try(network.switch_stp, null) != null
#       ]
#     ]
#   ])
# }

# resource "meraki_networks_switch_stp" "net_switch_stp" {
#   for_each            = { for i, v in local.networks_switch_stp : i => v }
#   network_id          = each.value.network_id
#   rstp_enabled        = try(each.value.data.rstp_enabled, null)
#   stp_bridge_priority = try(each.value.data.stp_bridge_priority, null)
#   # stp_bridge_priority_response = try(each.value.data.stp_bridge_priority_response, null)
# }

# locals {
#   networks_switch_stacks = flatten([
#     for domain in try(local.meraki.domains, []) : [
#       for org in try(domain.organizations, []) : [
#         for network in try(org.networks, []) : [
#           for switch_stack in try(network.switch_stacks, []) : {
#             stack_key  = format("%s/%s/%s/stacks/%s", domain.name, org.name, network.name, switch_stack.name)
#             data       = switch_stack
#             network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
#           }
#         ]
#       ]
#     ]
#   ])
# }

# resource "meraki_networks_switch_stacks" "net_switch_stacks" {
#   for_each = { for switch_stack in local.networks_switch_stacks : switch_stack.stack_key => switch_stack }
#   # id = try(each.value.data.id, null)
#   network_id = each.value.network_id
#   name       = try(each.value.data.name, null)
#   serials    = try(each.value.data.serials, null)
#   # switch_stack_id = try(each.value.data.switch_stack_id, null)
# }

# locals {
#   networks_switch_stacks_routing_interfaces = flatten([
#     for domain in try(local.meraki.domains, []) : [
#       for org in try(domain.organizations, []) : [
#         for network in try(org.networks, []) : [
#           for switch_stack in try(network.switch_stacks, []) : [
#             for interface in try(switch_stack.routing_interfaces, []) : {
#               network_id      = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
#               switch_stack_id = meraki_networks_switch_stacks.net_switch_stacks["${domain.name}/${org.name}/${network.name}/stacks/${switch_stack.name}"].id
#               interface_key   = format("%s/%s/%s/stacks/%s/interfaces/%s", domain.name, org.name, network.name, switch_stack.name, interface.name)
#               data            = interface
#             }
#           ]
#         ]
#       ]
#     ]
#   ])
# }

# resource "meraki_networks_switch_stacks_routing_interfaces" "net_switch_stacks_routing_interfaces" {
#   for_each        = { for i, v in local.networks_switch_stacks_routing_interfaces : i => v }
#   switch_stack_id = each.value.switch_stack_id
#   network_id      = each.value.network_id
#   default_gateway = try(each.value.data.default_gateway, null)
#   # interface_id      = try(each.value.data.interface_id, null)
#   interface_ip      = try(each.value.data.interface_ip, null)
#   ipv6              = try(each.value.data.ipv6, null)
#   multicast_routing = try(each.value.data.multicast_routing, null)
#   name              = try(each.value.data.name, null)
#   ospf_settings     = try(each.value.data.ospf_settings, null)
#   # ospf_v3           = try(each.value.data.ospf_v3, null)
#   subnet  = try(each.value.data.subnet, null)
#   vlan_id = try(each.value.data.vlan_id, null)
# }


# # locals {
# #   networks_switch_stacks_routing_interfaces_dhcp = flatten([
# #     for domain in try(local.meraki.domains, []) : [
# #       for org in try(domain.organizations, []) : [
# #         for network in try(org.networks, []) : [
# #           for switch_stack in try(network.switch_stacks, []) : [
# #             for interface in try(switch_stack.routing_interfaces, []) : {
# #               network_id      = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
# #               switch_stack_id = meraki_networks_switch_stacks.net_switch_stacks["${domain.name}/${org.name}/${network.name}/stacks/${switch_stack.name}"].id
# #               interface_id    = meraki_networks_switch_stacks_routing_interfaces.net_switch_stacks_routing_interfaces["${domain.name}/${org.name}/${network.name}/stacks/${switch_stack.name}/interfaces/${interface.name}"].interface_id
# #               data            = interface.dhcp
# #             } if try(interface.dhcp, null) != null
# #           ]
# #         ]
# #       ]
# #     ]
# #   ])
# # }

# # resource "meraki_networks_switch_stacks_routing_interfaces_dhcp" "net_switch_stacks_routing_interfaces_dhcp" {
# #   for_each               = { for i, v in local.i => v }
# #   network_id             = each.value.network_id
# #   switch_stack_id        = each.value.switch_stack_id
# #   interface_id           = each.value.interface_id
# #   boot_file_name         = try(each.value.data.boot_file_name, null)
# #   boot_next_server       = try(each.value.data.boot_next_server, null)
# #   boot_options_enabled   = try(each.value.data.boot_options_enabled, null)
# #   dhcp_lease_time        = try(each.value.data.dhcp_lease_time, null)
# #   dhcp_mode              = try(each.value.data.dhcp_mode, null)
# #   dhcp_options           = try(each.value.data.dhcp_options, null)
# #   dhcp_relay_server_ips  = try(each.value.data.dhcp_relay_server_ips, null)
# #   dns_custom_nameservers = try(each.value.data.dns_custom_nameservers, null)
# #   dns_nameservers_option = try(each.value.data.dns_nameservers_option, null)
# #   fixed_ip_assignments   = try(each.value.data.fixed_ip_assignments, null)
# #   reserved_ip_ranges     = try(each.value.data.reserved_ip_ranges, null)
# # }



# locals {
#   networks_switch_stacks_routing_static_routes = flatten([
#     for domain in try(local.meraki.domains, []) : [
#       for org in try(domain.organizations, []) : [
#         for network in try(org.networks, []) : [
#           for switch_stack in try(network.switch_stacks, []) : [
#             for static_route in try(switch_stack.routing_static_routes, []) : {
#               network_id      = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
#               switch_stack_id = meraki_networks_switch_stacks.net_switch_stacks["${domain.name}/${org.name}/${network.name}/stacks/${switch_stack.name}"].id
#               data            = static_route
#             }
#           ]
#         ]
#       ]
#     ]
#   ])
# }

# resource "meraki_networks_switch_stacks_routing_static_routes" "net_switch_stacks_routing_static_routes" {
#   for_each                        = { for i, v in local.networks_switch_stacks_routing_static_routes : i => v }
#   network_id                      = each.value.network_id
#   switch_stack_id                 = each.value.switch_stack_id
#   # advertise_via_ospf_enabled      = try(each.value.data.advertise_via_ospf_enabled, null)
#   name                            = try(each.value.data.name, null)
#   next_hop_ip                     = try(each.value.data.next_hop_ip, null)
#   # prefer_over_ospf_routes_enabled = try(each.value.data.prefer_over_ospf_routes_enabled, null)
#   subnet                          = try(each.value.data.subnet, null)
#   # static_route_id                 = try(each.value.data.static_route_id, null)
# }

# locals {
#   networks_syslog_servers = flatten([
#     for domain in try(local.meraki.domains, []) : [
#       for org in try(domain.organizations, []) : [
#         for network in try(org.networks, []) : {
#           network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
#           data       = network.syslog_servers
#         } if try(network.syslog_servers, null) != null
#       ]
#     ]
#   ])
# }

# resource "meraki_networks_syslog_servers" "net_syslog_servers" {
#   for_each   = { for i, v in local.networks_syslog_servers : i => v }
#   network_id = each.value.network_id
#   servers    = try(each.value.data.servers, null)
# }

# locals {
#   networks_vlan_profiles = flatten([
#     for domain in try(local.meraki.domains, []) : [
#       for org in try(domain.organizations, []) : [
#         for network in try(org.networks, []) : [
#           for vlan_profile in try(network.vlan_profiles, []) : {
#             network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
#             data       = vlan_profile
#           }
#         ]
#       ]
#     ]
#   ])
# }

# resource "meraki_networks_vlan_profiles" "net_vlan_profiles" {
#   for_each   = { for i, v in local.networks_vlan_profiles : i => v }
#   network_id = each.value.network_id
#   iname      = try(each.value.data.iname, null)
#   # is_default  = try(each.value.data.is_default, null)
#   name        = try(each.value.data.name, null)
#   vlan_groups = try(each.value.data.vlan_groups, null)
#   vlan_names  = try(each.value.data.vlan_names, null)
# }

# locals {
#   networks_wireless_rf_profiles = flatten([
#     for domain in try(local.meraki.domains, []) : [
#       for org in try(domain.organizations, []) : [
#         for network in try(org.networks, []) : [
#           for wireless_rf_profile in try(network.wireless_rf_profiles, []) : {
#             network_id     = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
#             rf_profile_key = format("%s/%s/%s/wireless_rf_profiles/%s", domain.name, org.name, network.name, wireless_rf_profile.name)
#             data           = wireless_rf_profile
#           }
#         ]
#       ]
#     ]
#   ])
# }

# resource "meraki_networks_wireless_rf_profiles" "net_wireless_rf_profiles" {
#   for_each                 = { for i, v in local.networks_wireless_rf_profiles : i => v }
#   network_id               = each.value.network_id
#   ap_band_settings         = try(each.value.data.ap_band_settings, null)
#   band_selection_type      = try(each.value.data.band_selection_type, null)
#   client_balancing_enabled = try(each.value.data.client_balancing_enabled, null)
#   five_ghz_settings        = try(each.value.data.five_ghz_settings, null)
#   flex_radios              = try(each.value.data.flex_radios, null)
#   min_bitrate_type         = try(each.value.data.min_bitrate_type, null)
#   name                     = try(each.value.data.name, null)
#   per_ssid_settings        = try(each.value.data.per_ssid_settings, null)
#   rf_profile_id            = try(each.value.data.rf_profile_id, null)
#   six_ghz_settings         = try(each.value.data.six_ghz_settings, null)
#   transmission             = try(each.value.data.transmission, null)
#   two_four_ghz_settings    = try(each.value.data.two_four_ghz_settings, null)
# }

# locals {
#   networks_wireless_settings = flatten([
#     for domain in try(local.meraki.domains, []) : [
#       for org in try(domain.organizations, []) : [
#         for network in try(org.networks, []) : {
#           network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
#           data       = network.wireless_settings
#         } if try(network.wireless_settings, null) != null
#       ]
#     ]
#   ])
# }

# resource "meraki_networks_wireless_settings" "net_wireless_settings" {
#   for_each                   = { for i, v in local.networks_wireless_settings : i => v }
#   network_id                 = each.value.network_id
#   ipv6_bridge_enabled        = try(each.value.data.ipv6_bridge_enabled, null)
#   led_lights_on              = try(each.value.data.led_lights_on, null)
#   location_analytics_enabled = try(each.value.data.location_analytics_enabled, null)
#   meshing_enabled            = try(each.value.data.meshing_enabled, null)
#   named_vlans                = try(each.value.data.named_vlans, null)
#   # regulatory_domain          = try(each.value.data.regulatory_domain, null)
#   upgradestrategy = try(each.value.data.upgradestrategy, null)
# }

# locals {
#   networks_wireless_ssids = flatten([
#     for domain in try(local.meraki.domains, []) : [
#       for org in try(domain.organizations, []) : [
#         for network in try(org.networks, []) : [
#           for wireless_ssid in try(network.wireless_ssids, []) : {
#             wireless_ssid_key = format("%s/%s/%s/wireless_ssids/%s", domain.name, org.name, network.name, wireless_ssid.name)
#             data              = wireless_ssid
#             network_id        = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
#           }
#         ]
#       ]
#     ]
#   ])
# }

# resource "meraki_networks_wireless_ssids" "net_wireless_ssids" {
#   for_each                             = { for i, v in local.networks_wireless_ssids : i => v }
#   network_id                           = each.value.network_id
#   number                               = each.value.number
#   active_directory                     = try(each.value.data.active_directory, null)
#   # admin_splash_url                     = try(each.value.data.admin_splash_url, null)
#   adult_content_filtering_enabled      = try(each.value.data.adult_content_filtering_enabled, null)
#   ap_tags_and_vlan_ids                 = try(each.value.data.ap_tags_and_vlan_ids, null)
#   auth_mode                            = try(each.value.data.auth_mode, null)
#   availability_tags                    = try(each.value.data.availability_tags, null)
#   available_on_all_aps                 = try(each.value.data.available_on_all_aps, null)
#   band_selection                       = try(each.value.data.band_selection, null)
#   concentrator_network_id              = try(each.value.data.concentrator_network_id, null)
#   default_vlan_id                      = try(each.value.data.default_vlan_id, null)
#   disassociate_clients_on_vpn_failover = try(each.value.data.disassociate_clients_on_vpn_failover, null)
#   dns_rewrite                          = try(each.value.data.dns_rewrite, null)
#   dot11r                               = try(each.value.data.dot11r, null)
#   dot11w                               = try(each.value.data.dot11w, null)
#   enabled                              = try(each.value.data.enabled, null)
#   encryption_mode                      = try(each.value.data.encryption_mode, null)
#   enterprise_admin_access              = try(each.value.data.enterprise_admin_access, null)
#   gre                                  = try(each.value.data.gre, null)
#   ip_assignment_mode                   = try(each.value.data.ip_assignment_mode, null)
#   lan_isolation_enabled                = try(each.value.data.lan_isolation_enabled, null)
#   ldap                                 = try(each.value.data.ldap, null)
#   # local_auth                           = try(each.value.data.local_auth, null)
#   local_radius                         = try(each.value.data.local_radius, null)
#   mandatory_dhcp_enabled               = try(each.value.data.mandatory_dhcp_enabled, null)
#   min_bitrate                          = try(each.value.data.min_bitrate, null)
#   name                                 = try(each.value.data.name, null)
#   named_vlans                          = try(each.value.data.named_vlans, null)
#   oauth                                = try(each.value.data.oauth, null)
#   per_client_bandwidth_limit_down      = try(each.value.data.per_client_bandwidth_limit_down, null)
#   per_client_bandwidth_limit_up        = try(each.value.data.per_client_bandwidth_limit_up, null)
#   per_ssid_bandwidth_limit_down        = try(each.value.data.per_ssid_bandwidth_limit_down, null)
#   per_ssid_bandwidth_limit_up          = try(each.value.data.per_ssid_bandwidth_limit_up, null)
#   psk                                  = try(each.value.data.psk, null)
#   radius_accounting_enabled            = try(each.value.data.radius_accounting_enabled, null)
#   radius_accounting_interim_interval   = try(each.value.data.radius_accounting_interim_interval, null)
#   radius_accounting_servers            = try(each.value.data.radius_accounting_servers, null)
#   radius_attribute_for_group_policies  = try(each.value.data.radius_attribute_for_group_policies, null)
#   radius_authentication_nas_id         = try(each.value.data.radius_authentication_nas_id, null)
#   radius_called_station_id             = try(each.value.data.radius_called_station_id, null)
#   radius_coa_enabled                   = try(each.value.data.radius_coa_enabled, null)
#   # radius_enabled                       = try(each.value.data.radius_enabled, null)
#   radius_failover_policy               = try(each.value.data.radius_failover_policy, null)
#   radius_fallback_enabled              = try(each.value.data.radius_fallback_enabled, null)
#   radius_guest_vlan_enabled            = try(each.value.data.radius_guest_vlan_enabled, null)
#   radius_guest_vlan_id                 = try(each.value.data.radius_guest_vlan_id, null)
#   radius_load_balancing_policy         = try(each.value.data.radius_load_balancing_policy, null)
#   radius_override                      = try(each.value.data.radius_override, null)
#   radius_proxy_enabled                 = try(each.value.data.radius_proxy_enabled, null)
#   radius_server_attempts_limit         = try(each.value.data.radius_server_attempts_limit, null)
#   radius_server_timeout                = try(each.value.data.radius_server_timeout, null)
#   radius_servers                       = try(each.value.data.radius_servers, null)
#   # radius_servers_response              = try(each.value.data.radius_servers_response, null)
#   radius_testing_enabled               = try(each.value.data.radius_testing_enabled, null)
#   secondary_concentrator_network_id    = try(each.value.data.secondary_concentrator_network_id, null)
#   speed_burst                          = try(each.value.data.speed_burst, null)
#   splash_guest_sponsor_domains         = try(each.value.data.splash_guest_sponsor_domains, null)
#   splash_page                          = try(each.value.data.splash_page, null)
#   # splash_timeout                       = try(each.value.data.splash_timeout, null)
#   # ssid_admin_accessible                = try(each.value.data.ssid_admin_accessible, null)
#   use_vlan_tagging                     = try(each.value.data.use_vlan_tagging, null)
#   visible                              = try(each.value.data.visible, null)
#   vlan_id                              = try(each.value.data.vlan_id, null)
#   walled_garden_enabled                = try(each.value.data.walled_garden_enabled, null)
#   walled_garden_ranges                 = try(each.value.data.walled_garden_ranges, null)
#   wpa_encryption_mode                  = try(each.value.data.wpa_encryption_mode, null)
# }
