locals {
  devices = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for device in try(network.devices, []) : {
            key  = format("%s/%s/devices/%s", organization.name, network.name, device.name)
            data = device
          }
        ]
      ]
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_device" "device" {
  for_each        = { for dev in local.devices : dev.key => dev }
  serial          = each.value.data.serial
  name            = try(each.value.data.name, local.defaults.meraki.devices.name, null)
  tags            = try(each.value.data.tags, local.defaults.meraki.devices.tags, null)
  lat             = try(each.value.data.lat, local.defaults.meraki.devices.lat, null)
  lng             = try(each.value.data.lng, local.defaults.meraki.devices.lng, null)
  address         = try(each.value.data.address, local.defaults.meraki.devices.address, null)
  notes           = try(each.value.data.notes, local.defaults.meraki.devices.notes, null)
  move_map_marker = try(each.value.data.move_map_marker, local.defaults.meraki.devices.move_map_marker, null)
  #   switch_profile_id = try(each.value.data.switch_profile_id, local.defaults.meraki.devices.switch_profile_id, null)
  #   floor_plan_id = try(each.value.data.floor_plan_id, local.defaults.meraki.devices.floor_plan_id, null)
  depends_on = [meraki_network_device_claim.net_device_claim]
}

locals {
  devices_appliance_uplinks_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for device in try(network.devices, []) : {
            device_serial = meraki_device.device["${organization.name}/${network.name}/devices/${device.name}"].serial
            data          = try(device.appliance_uplinks_settings, null)
          } if try(device.appliance_uplinks_settings, null) != null
        ]
      ]
    ]
  ])
}

resource "meraki_appliance_uplinks_settings" "devices_appliance_uplinks_setting" {
  for_each                                        = { for i, v in local.devices_appliance_uplinks_settings : i => v }
  serial                                          = each.value.device_serial
  interfaces_wan1_enabled                         = try(each.value.data.interfaces.wan1.enabled, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan1.enabled, null)
  interfaces_wan1_vlan_tagging_enabled            = try(each.value.data.interfaces.wan1.vlan_tagging.enabled, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan1.vlan_tagging.enabled, null)
  interfaces_wan1_vlan_tagging_vlan_id            = try(each.value.data.interfaces.wan1.vlan_tagging.vlan_id, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan1.vlan_tagging.vlan_id, null)
  interfaces_wan1_svis_ipv4_assignment_mode       = try(each.value.data.interfaces.wan1.svis.ipv4.assignment_mode, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan1.svis.ipv4.assignment_mode, null)
  interfaces_wan1_svis_ipv4_address               = try(each.value.data.interfaces.wan1.svis.ipv4.address, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan1.svis.ipv4.address, null)
  interfaces_wan1_svis_ipv4_gateway               = try(each.value.data.interfaces.wan1.svis.ipv4.gateway, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan1.svis.ipv4.gateway, null)
  interfaces_wan1_svis_ipv4_nameservers_addresses = try(each.value.data.interfaces.wan1.svis.ipv4.nameservers.addresses, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan1.svis.ipv4.nameservers.addresses, null)
  interfaces_wan1_svis_ipv6_assignment_mode       = try(each.value.data.interfaces.wan1.svis.ipv6.assignment_mode, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan1.svis.ipv6.assignment_mode, null)
  interfaces_wan1_svis_ipv6_address               = try(each.value.data.interfaces.wan1.svis.ipv6.address, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan1.svis.ipv6.address, null)
  interfaces_wan1_svis_ipv6_gateway               = try(each.value.data.interfaces.wan1.svis.ipv6.gateway, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan1.svis.ipv6.gateway, null)
  interfaces_wan1_svis_ipv6_nameservers_addresses = try(each.value.data.interfaces.wan1.svis.ipv6.nameservers.addresses, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan1.svis.ipv6.nameservers.addresses, null)
  interfaces_wan1_pppoe_enabled                   = try(each.value.data.interfaces.wan1.pppoe.enabled, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan1.pppoe.enabled, null)
  interfaces_wan1_pppoe_authentication_enabled    = try(each.value.data.interfaces.wan1.pppoe.authentication.enabled, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan1.pppoe.authentication.enabled, null)
  interfaces_wan1_pppoe_authentication_username   = try(each.value.data.interfaces.wan1.pppoe.authentication.username, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan1.pppoe.authentication.username, null)
  interfaces_wan1_pppoe_authentication_password   = try(each.value.data.interfaces.wan1.pppoe.authentication.password, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan1.pppoe.authentication.password, null)
  interfaces_wan2_enabled                         = try(each.value.data.interfaces.wan2.enabled, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan2.enabled, null)
  interfaces_wan2_vlan_tagging_enabled            = try(each.value.data.interfaces.wan2.vlan_tagging.enabled, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan2.vlan_tagging.enabled, null)
  interfaces_wan2_vlan_tagging_vlan_id            = try(each.value.data.interfaces.wan2.vlan_tagging.vlan_id, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan2.vlan_tagging.vlan_id, null)
  interfaces_wan2_svis_ipv4_assignment_mode       = try(each.value.data.interfaces.wan2.svis.ipv4.assignment_mode, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan2.svis.ipv4.assignment_mode, null)
  interfaces_wan2_svis_ipv4_address               = try(each.value.data.interfaces.wan2.svis.ipv4.address, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan2.svis.ipv4.address, null)
  interfaces_wan2_svis_ipv4_gateway               = try(each.value.data.interfaces.wan2.svis.ipv4.gateway, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan2.svis.ipv4.gateway, null)
  interfaces_wan2_svis_ipv4_nameservers_addresses = try(each.value.data.interfaces.wan2.svis.ipv4.nameservers.addresses, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan2.svis.ipv4.nameservers.addresses, null)
  interfaces_wan2_svis_ipv6_assignment_mode       = try(each.value.data.interfaces.wan2.svis.ipv6.assignment_mode, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan2.svis.ipv6.assignment_mode, null)
  interfaces_wan2_svis_ipv6_address               = try(each.value.data.interfaces.wan2.svis.ipv6.address, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan2.svis.ipv6.address, null)
  interfaces_wan2_svis_ipv6_gateway               = try(each.value.data.interfaces.wan2.svis.ipv6.gateway, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan2.svis.ipv6.gateway, null)
  interfaces_wan2_svis_ipv6_nameservers_addresses = try(each.value.data.interfaces.wan2.svis.ipv6.nameservers.addresses, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan2.svis.ipv6.nameservers.addresses, null)
  interfaces_wan2_pppoe_enabled                   = try(each.value.data.interfaces.wan2.pppoe.enabled, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan2.pppoe.enabled, null)
  interfaces_wan2_pppoe_authentication_enabled    = try(each.value.data.interfaces.wan2.pppoe.authentication.enabled, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan2.pppoe.authentication.enabled, null)
  interfaces_wan2_pppoe_authentication_username   = try(each.value.data.interfaces.wan2.pppoe.authentication.username, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan2.pppoe.authentication.username, null)
  interfaces_wan2_pppoe_authentication_password   = try(each.value.data.interfaces.wan2.pppoe.authentication.password, local.defaults.meraki.networks.devices_appliance_uplinks_settings.interfaces.wan2.pppoe.authentication.password, null)
}

locals {
  devices_management_interface = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for device in try(network.devices, []) : {
            device_serial = meraki_device.device["${organization.name}/${network.name}/devices/${device.name}"].serial
            data          = try(device.management_interface, null)
          } if try(device.management_interface, null) != null
        ]
      ]
    ]
  ])
}

resource "meraki_device_management_interface" "devices_management_interface" {
  for_each                = { for i, v in local.devices_management_interface : i => v }
  serial                  = each.value.device_serial
  wan1_wan_enabled        = try(each.value.data.wan1.wan, local.defaults.meraki.networks.devices_management_interface.wan1.wan, null)
  wan1_using_static_ip    = try(each.value.data.wan1.using_static_ip, local.defaults.meraki.networks.devices_management_interface.wan1.using_static_ip, null)
  wan1_static_ip          = try(each.value.data.wan1.static_ip, local.defaults.meraki.networks.devices_management_interface.wan1.static_ip, null)
  wan1_static_gateway_ip  = try(each.value.data.wan1.static_gateway_ip, local.defaults.meraki.networks.devices_management_interface.wan1.static_gateway_ip, null)
  wan1_static_subnet_mask = try(each.value.data.wan1.static_subnet_mask, local.defaults.meraki.networks.devices_management_interface.wan1.static_subnet_mask, null)
  wan1_static_dns         = try(each.value.data.wan1.static_dns, local.defaults.meraki.networks.devices_management_interface.wan1.static_dns, null)
  wan1_vlan               = try(each.value.data.wan1.vlan, local.defaults.meraki.networks.devices_management_interface.wan1.vlan, null)
  wan2_wan_enabled        = try(each.value.data.wan2.wan, local.defaults.meraki.networks.devices_management_interface.wan2.wan, null)
  wan2_using_static_ip    = try(each.value.data.wan2.using_static_ip, local.defaults.meraki.networks.devices_management_interface.wan2.using_static_ip, null)
  wan2_static_ip          = try(each.value.data.wan2.static_ip, local.defaults.meraki.networks.devices_management_interface.wan2.static_ip, null)
  wan2_static_gateway_ip  = try(each.value.data.wan2.static_gateway_ip, local.defaults.meraki.networks.devices_management_interface.wan2.static_gateway_ip, null)
  wan2_static_subnet_mask = try(each.value.data.wan2.static_subnet_mask, local.defaults.meraki.networks.devices_management_interface.wan2.static_subnet_mask, null)
  wan2_static_dns         = try(each.value.data.wan2.static_dns, local.defaults.meraki.networks.devices_management_interface.wan2.static_dns, null)
  wan2_vlan               = try(each.value.data.wan2.vlan, local.defaults.meraki.networks.devices_management_interface.wan2.vlan, null)
}

locals {
  devices_switch_ports = concat(flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for device in try(network.devices, []) : [
            for switch_port in try(device.switch_ports, []) : [
              for port_id in split(",", switch_port.port_ids) : {
                device_serial            = meraki_device.device["${organization.name}/${network.name}/devices/${device.name}"].serial
                data                     = merge(switch_port, { port_id = port_id })
                port_schedule_id         = meraki_switch_port_schedule.net_switch_port_schedules["${organization.name}/${network.name}/port_schedules/${switch_port.port_schedule_name}"].id
                adaptive_policy_group_id = try(meraki_organization_adaptive_policy_group.organizations_adaptive_policy_group[format("%s/adaptive_policy_groups/%s", organization.name, switch_port.adaptive_policy_group_name)].id, null)
              } if replace(port_id, "-", "") == port_id
            ]
          ]
        ]
      ]
    ]
    ]),
    flatten([
      for domain in try(local.meraki.domains, []) : [
        for organization in try(domain.organizations, []) : [
          for network in try(organization.networks, []) : [
            for device in try(network.devices, []) : [
              for switch_port in try(device.switch_ports, []) : [
                for port_range in split(",", switch_port.port_ids) : [
                  for p in range(split("-", port_range)[0], split("-", port_range)[1]) : {
                    device_serial            = meraki_device.device["${organization.name}/${network.name}/devices/${device.name}"].serial
                    data                     = merge(switch_port, { port_id = p })
                    port_schedule_id         = meraki_switch_port_schedule.net_switch_port_schedules["${organization.name}/${network.name}/port_schedules/${switch_port.port_schedule_name}"].id
                    adaptive_policy_group_id = try(meraki_organization_adaptive_policy_group.organizations_adaptive_policy_group[format("%s/adaptive_policy_groups/%s", organization.name, switch_port.adaptive_policy_group_name)].id, null)
                  }
                ] if replace(port_range, "-", "") != port_range
              ]
            ]
          ]
        ]
      ]
    ])
  )
}

resource "meraki_switch_port" "devices_switch_port" {
  for_each                    = { for i, v in local.devices_switch_ports : i => v }
  serial                      = each.value.device_serial
  port_id                     = each.value.data.port_id
  name                        = try(each.value.data.name, local.defaults.meraki.networks.devices_switch_ports.name, null)
  tags                        = try(each.value.data.tags, local.defaults.meraki.networks.devices_switch_ports.tags, null)
  enabled                     = try(each.value.data.enabled, local.defaults.meraki.networks.devices_switch_ports.enabled, null)
  poe_enabled                 = try(each.value.data.poe, local.defaults.meraki.networks.switch.port_schedules.poe, null)
  type                        = try(each.value.data.type, local.defaults.meraki.networks.devices_switch_ports.type, null)
  vlan                        = try(each.value.data.vlan, local.defaults.meraki.networks.devices_switch_ports.vlan, null)
  voice_vlan                  = try(each.value.data.voice_vlan, local.defaults.meraki.networks.devices_switch_ports.voice_vlan, null)
  allowed_vlans               = try(each.value.data.allowed_vlans, local.defaults.meraki.networks.devices_switch_ports.allowed_vlans, null)
  isolation_enabled           = try(each.value.data.isolation, local.defaults.meraki.networks.switch.port_schedules.isolation, null)
  rstp_enabled                = try(each.value.data.rstp, local.defaults.meraki.networks.switch.port_schedules.rstp, null)
  stp_guard                   = try(each.value.data.stp_guard, local.defaults.meraki.networks.devices_switch_ports.stp_guard, null)
  link_negotiation            = try(each.value.data.link_negotiation, local.defaults.meraki.networks.devices_switch_ports.link_negotiation, null)
  port_schedule_id            = each.value.port_schedule_id
  udld                        = try(each.value.data.udld, local.defaults.meraki.networks.devices_switch_ports.udld, null)
  access_policy_type          = try(each.value.data.access_policy_type, local.defaults.meraki.networks.devices_switch_ports.access_policy_type, null)
  access_policy_number        = try(each.value.data.access_policy_number, local.defaults.meraki.networks.devices_switch_ports.access_policy_number, null)
  mac_allow_list              = try(each.value.data.mac_allow_list, local.defaults.meraki.networks.devices_switch_ports.mac_allow_list, null)
  sticky_mac_allow_list       = try(each.value.data.sticky_mac_allow_list, local.defaults.meraki.networks.devices_switch_ports.sticky_mac_allow_list, null)
  sticky_mac_allow_list_limit = try(each.value.data.sticky_mac_allow_list_limit, local.defaults.meraki.networks.devices_switch_ports.sticky_mac_allow_list_limit, null)
  storm_control_enabled       = try(each.value.data.storm_control, local.defaults.meraki.networks.switch.port_schedules.storm_control, null)
  adaptive_policy_group_id    = each.value.adaptive_policy_group_id
  peer_sgt_capable            = try(each.value.data.peer_sgt_capable, local.defaults.meraki.networks.devices_switch_ports.peer_sgt_capable, null)
  flexible_stacking_enabled   = try(each.value.data.flexible_stacking, local.defaults.meraki.networks.switch.port_schedules.flexible_stacking, null)
  dai_trusted                 = try(each.value.data.dai_trusted, local.defaults.meraki.networks.devices_switch_ports.dai_trusted, null)
  profile_enabled             = try(each.value.data.profile.enabled, local.defaults.meraki.networks.devices_switch_ports.profile.enabled, null)
  # profile_id                  = try(each.value.data.profile.id, local.defaults.meraki.networks.devices_switch_ports.profile.id, null)
  profile_iname  = try(each.value.data.profile.iname, local.defaults.meraki.networks.devices_switch_ports.profile.iname, null)
  dot3az_enabled = try(each.value.data.dot3az.enabled, local.defaults.meraki.networks.devices_switch_ports.dot3az.enabled, null)

}

locals {
  devices_switch_routing_interfaces = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for device in try(network.devices, []) : [
            for switch_routing_interface in try(device.switch_routing_interfaces, []) : {
              device_serial = meraki_device.device["${organization.name}/${network.name}/devices/${device.name}"].serial
              interface_key = format("%s/%s/switch_routing_interfaces/%s", organization.name, network.name, switch_routing_interface.name)
              data          = switch_routing_interface
            }
          ] if try(device.switch_routing_interfaces, null) != null
        ]
      ]
    ]
  ])
}

resource "meraki_switch_routing_interface" "devices_switch_routing_interface" {
  for_each                         = { for i in local.devices_switch_routing_interfaces : i.interface_key => i }
  serial                           = each.value.device_serial
  name                             = try(each.value.data.name, local.defaults.meraki.networks.devices_switch_routing_interfaces.name, null)
  subnet                           = try(each.value.data.subnet, local.defaults.meraki.networks.devices_switch_routing_interfaces.subnet, null)
  interface_ip                     = try(each.value.data.interface_ip, local.defaults.meraki.networks.devices_switch_routing_interfaces.interface_ip, null)
  multicast_routing                = try(each.value.data.multicast_routing, local.defaults.meraki.networks.devices_switch_routing_interfaces.multicast_routing, null)
  vlan_id                          = try(each.value.data.vlan_id, local.defaults.meraki.networks.devices_switch_routing_interfaces.vlan_id, null)
  default_gateway                  = try(each.value.data.default_gateway, local.defaults.meraki.networks.devices_switch_routing_interfaces.default_gateway, null)
  ospf_settings_area               = try(each.value.data.ospf_settings.area, local.defaults.meraki.networks.devices_switch_routing_interfaces.ospf_settings.area, null)
  ospf_settings_cost               = try(each.value.data.ospf_settings.cost, local.defaults.meraki.networks.devices_switch_routing_interfaces.ospf_settings.cost, null)
  ospf_settings_is_passive_enabled = try(each.value.data.ospf_settings.is_passive, local.defaults.meraki.networks.devices_switch_routing_interfaces.ospf_settings.is_passive, null)
  ipv6_assignment_mode             = try(each.value.data.ipv6.assignment_mode, local.defaults.meraki.networks.devices_switch_routing_interfaces.ipv6.assignment_mode, null)
  ipv6_prefix                      = try(each.value.data.ipv6.prefix, local.defaults.meraki.networks.devices_switch_routing_interfaces.ipv6.prefix, null)
  ipv6_address                     = try(each.value.data.ipv6.address, local.defaults.meraki.networks.devices_switch_routing_interfaces.ipv6.address, null)
  ipv6_gateway                     = try(each.value.data.ipv6.gateway, local.defaults.meraki.networks.devices_switch_routing_interfaces.ipv6.gateway, null)
}

locals {
  devices_switch_routing_interfaces_dhcp = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for device in try(network.devices, []) : [
            for switch_routing_interface in try(device.switch_routing_interfaces, []) : {
              device_serial = meraki_device.device["${organization.name}/${network.name}/devices/${device.name}"].serial
              interface_id  = meraki_switch_routing_interface.devices_switch_routing_interface["${organization.name}/${network.name}/switch_routing_interfaces/${switch_routing_interface.name}"].id
              data          = try(switch_routing_interface.dhcp, null)
            } if try(switch_routing_interface.dhcp, null) != null
          ]
        ]
      ]
    ]
  ])
}

resource "meraki_switch_routing_interface_dhcp" "devices_switch_routing_interfaces_dhcp" {
  for_each               = { for i, v in local.devices_switch_routing_interfaces_dhcp : i => v }
  interface_id           = each.value.interface_id
  serial                 = each.value.device_serial
  dhcp_mode              = try(each.value.data.dhcp_mode, local.defaults.meraki.networks.devices_switch_routing_interfaces_dhcp.dhcp_mode, null)
  dhcp_relay_server_ips  = try(each.value.data.dhcp_relay_server_ips, local.defaults.meraki.networks.devices_switch_routing_interfaces_dhcp.dhcp_relay_server_ips, null)
  dhcp_lease_time        = try(each.value.data.dhcp_lease_time, local.defaults.meraki.networks.devices_switch_routing_interfaces_dhcp.dhcp_lease_time, null)
  dns_nameservers_option = try(each.value.data.dns_nameservers_option, local.defaults.meraki.networks.devices_switch_routing_interfaces_dhcp.dns_nameservers_option, null)
  dns_custom_nameservers = try(each.value.data.dns_custom_nameservers, local.defaults.meraki.networks.devices_switch_routing_interfaces_dhcp.dns_custom_nameservers, null)
  boot_options_enabled   = try(each.value.data.boot_options, local.defaults.meraki.networks.devices_switch_routing_interfaces_dhcp.boot_options, null)
  boot_next_server       = try(each.value.data.boot_next_server, local.defaults.meraki.networks.devices_switch_routing_interfaces_dhcp.boot_next_server, null)
  boot_file_name         = try(each.value.data.boot_file_name, local.defaults.meraki.networks.devices_switch_routing_interfaces_dhcp.boot_file_name, null)
  dhcp_options           = try(each.value.data.dhcp_options, local.defaults.meraki.networks.devices_switch_routing_interfaces_dhcp.dhcp_options, null)
  reserved_ip_ranges     = try(each.value.data.reserved_ip_ranges, local.defaults.meraki.networks.devices_switch_routing_interfaces_dhcp.reserved_ip_ranges, null)
  fixed_ip_assignments   = try(each.value.data.fixed_ip_assignments, local.defaults.meraki.networks.devices_switch_routing_interfaces_dhcp.fixed_ip_assignments, null)
  depends_on             = [meraki_switch_routing_interface.devices_switch_routing_interface]
}

locals {
  devices_switch_routing_static_routes = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for device in try(network.devices, []) : [
            for switch_routing_static_route in try(device.switch_routing_static_routes, []) : {
              device_serial = meraki_device.device["${organization.name}/${network.name}/devices/${device.name}"].serial
              data          = switch_routing_static_route
            }
          ] if try(device.switch_routing_static_routes, null) != null
        ]
      ]
    ]
  ])
}

resource "meraki_switch_routing_static_route" "devices_switch_routing_static_routes" {
  for_each                        = { for i, v in local.devices_switch_routing_static_routes : i => v }
  serial                          = each.value.device_serial
  name                            = try(each.value.data.name, local.defaults.meraki.networks.devices_switch_routing_static_routes.name, null)
  subnet                          = try(each.value.data.subnet, local.defaults.meraki.networks.devices_switch_routing_static_routes.subnet, null)
  next_hop_ip                     = try(each.value.data.next_hop_ip, local.defaults.meraki.networks.devices_switch_routing_static_routes.next_hop_ip, null)
  advertise_via_ospf_enabled      = try(each.value.data.advertise_via_ospf, local.defaults.meraki.networks.devices_switch_routing_static_routes.advertise_via_ospf, null)
  prefer_over_ospf_routes_enabled = try(each.value.data.prefer_over_ospf_routes, local.defaults.meraki.networks.devices_switch_routing_static_routes.prefer_over_ospf_routes, null)
  depends_on                      = [meraki_switch_routing_interface.devices_switch_routing_interface]
}

locals {
  devices_wireless_bluetooth_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for device in try(network.devices, []) : {
            device_serial = meraki_device.device["${organization.name}/${network.name}/devices/${device.name}"].serial
            data          = device.wireless_bluetooth_settings
          } if try(device.wireless_bluetooth_settings, null) != null
        ]
      ]
    ]
  ])
}

resource "meraki_wireless_device_bluetooth_settings" "devices_wireless_bluetooth_settings" {
  for_each = { for i, v in local.devices_wireless_bluetooth_settings : i => v }
  serial   = each.value.device_serial
  uuid     = try(each.value.data.uuid, local.defaults.meraki.networks.devices_wireless_bluetooth_settings.uuid, null)
  major    = try(each.value.data.major, local.defaults.meraki.networks.devices_wireless_bluetooth_settings.major, null)
  minor    = try(each.value.data.minor, local.defaults.meraki.networks.devices_wireless_bluetooth_settings.minor, null)
}
