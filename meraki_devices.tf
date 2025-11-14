locals {
  devices = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for device in try(network.devices, []) : {
            key             = format("%s/%s/%s/%s", domain.name, organization.name, network.name, device.name)
            serial          = try(device.serial, local.defaults.meraki.domains.organizations.networks.devices.serial, null)
            name            = try(device.name, local.defaults.meraki.domains.organizations.networks.devices.name, null)
            tags            = try(device.tags, local.defaults.meraki.domains.organizations.networks.devices.tags, null)
            lat             = try(device.lat, local.defaults.meraki.domains.organizations.networks.devices.lat, null)
            lng             = try(device.lng, local.defaults.meraki.domains.organizations.networks.devices.lng, null)
            address         = try(device.address, local.defaults.meraki.domains.organizations.networks.devices.address, null)
            notes           = try(device.notes, local.defaults.meraki.domains.organizations.networks.devices.notes, null)
            move_map_marker = try(device.move_map_marker, local.defaults.meraki.domains.organizations.networks.devices.move_map_marker, null)
            #switch_profile_id = try(device.switch_profile_id, local.defaults.meraki.domains.organizations.networks.devices.switch_profile_id, null)
            floor_plan_id = try(meraki_network_floor_plan.networks_floor_plans[format("%s/%s/%s/%s", domain.name, organization.name, network.name, device.floor_plan_name)].id, null)
          }
        ]
      ]
    ]
  ])
}

resource "meraki_device" "devices" {
  for_each        = { for v in local.devices : v.key => v }
  serial          = each.value.serial
  name            = each.value.name
  tags            = each.value.tags
  lat             = each.value.lat
  lng             = each.value.lng
  address         = each.value.address
  notes           = each.value.notes
  move_map_marker = each.value.move_map_marker
  #switch_profile_id = each.value.switch_profile_id
  floor_plan_id = each.value.floor_plan_id
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}

locals {
  devices_appliance_uplinks_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for device in try(network.devices, []) : {
            key                                             = format("%s/%s/%s/%s", domain.name, organization.name, network.name, device.name)
            serial                                          = meraki_device.devices[format("%s/%s/%s/%s", domain.name, organization.name, network.name, device.name)].serial
            interfaces_wan1_enabled                         = try(device.appliance.uplinks_settings.wan1.enabled, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan1.enabled, null)
            interfaces_wan1_vlan_tagging_enabled            = try(device.appliance.uplinks_settings.wan1.vlan_tagging.enabled, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan1.vlan_tagging.enabled, null)
            interfaces_wan1_vlan_tagging_vlan_id            = try(device.appliance.uplinks_settings.wan1.vlan_tagging.vlan_id, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan1.vlan_tagging.vlan_id, null)
            interfaces_wan1_svis_ipv4_assignment_mode       = try(device.appliance.uplinks_settings.wan1.svis.ipv4.assignment_mode, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan1.svis.ipv4.assignment_mode, null)
            interfaces_wan1_svis_ipv4_address               = try(device.appliance.uplinks_settings.wan1.svis.ipv4.address, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan1.svis.ipv4.address, null)
            interfaces_wan1_svis_ipv4_gateway               = try(device.appliance.uplinks_settings.wan1.svis.ipv4.gateway, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan1.svis.ipv4.gateway, null)
            interfaces_wan1_svis_ipv4_nameservers_addresses = try(device.appliance.uplinks_settings.wan1.svis.ipv4.nameservers, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan1.svis.ipv4.nameservers, null)
            interfaces_wan1_svis_ipv6_assignment_mode       = try(device.appliance.uplinks_settings.wan1.svis.ipv6.assignment_mode, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan1.svis.ipv6.assignment_mode, null)
            interfaces_wan1_svis_ipv6_address               = try(device.appliance.uplinks_settings.wan1.svis.ipv6.address, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan1.svis.ipv6.address, null)
            interfaces_wan1_svis_ipv6_gateway               = try(device.appliance.uplinks_settings.wan1.svis.ipv6.gateway, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan1.svis.ipv6.gateway, null)
            interfaces_wan1_svis_ipv6_nameservers_addresses = try(device.appliance.uplinks_settings.wan1.svis.ipv6.nameservers, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan1.svis.ipv6.nameservers, null)
            interfaces_wan1_pppoe_enabled                   = try(device.appliance.uplinks_settings.wan1.pppoe.enabled, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan1.pppoe.enabled, null)
            interfaces_wan1_pppoe_authentication_enabled    = try(device.appliance.uplinks_settings.wan1.pppoe.authentication.enabled, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan1.pppoe.authentication.enabled, null)
            interfaces_wan1_pppoe_authentication_username   = try(device.appliance.uplinks_settings.wan1.pppoe.authentication.username, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan1.pppoe.authentication.username, null)
            interfaces_wan1_pppoe_authentication_password   = try(device.appliance.uplinks_settings.wan1.pppoe.authentication.password, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan1.pppoe.authentication.password, null)
            interfaces_wan2_enabled                         = try(device.appliance.uplinks_settings.wan2.enabled, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan2.enabled, null)
            interfaces_wan2_vlan_tagging_enabled            = try(device.appliance.uplinks_settings.wan2.vlan_tagging.enabled, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan2.vlan_tagging.enabled, null)
            interfaces_wan2_vlan_tagging_vlan_id            = try(device.appliance.uplinks_settings.wan2.vlan_tagging.vlan_id, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan2.vlan_tagging.vlan_id, null)
            interfaces_wan2_svis_ipv4_assignment_mode       = try(device.appliance.uplinks_settings.wan2.svis.ipv4.assignment_mode, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan2.svis.ipv4.assignment_mode, null)
            interfaces_wan2_svis_ipv4_address               = try(device.appliance.uplinks_settings.wan2.svis.ipv4.address, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan2.svis.ipv4.address, null)
            interfaces_wan2_svis_ipv4_gateway               = try(device.appliance.uplinks_settings.wan2.svis.ipv4.gateway, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan2.svis.ipv4.gateway, null)
            interfaces_wan2_svis_ipv4_nameservers_addresses = try(device.appliance.uplinks_settings.wan2.svis.ipv4.nameservers, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan2.svis.ipv4.nameservers, null)
            interfaces_wan2_svis_ipv6_assignment_mode       = try(device.appliance.uplinks_settings.wan2.svis.ipv6.assignment_mode, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan2.svis.ipv6.assignment_mode, null)
            interfaces_wan2_svis_ipv6_address               = try(device.appliance.uplinks_settings.wan2.svis.ipv6.address, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan2.svis.ipv6.address, null)
            interfaces_wan2_svis_ipv6_gateway               = try(device.appliance.uplinks_settings.wan2.svis.ipv6.gateway, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan2.svis.ipv6.gateway, null)
            interfaces_wan2_svis_ipv6_nameservers_addresses = try(device.appliance.uplinks_settings.wan2.svis.ipv6.nameservers, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan2.svis.ipv6.nameservers, null)
            interfaces_wan2_pppoe_enabled                   = try(device.appliance.uplinks_settings.wan2.pppoe.enabled, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan2.pppoe.enabled, null)
            interfaces_wan2_pppoe_authentication_enabled    = try(device.appliance.uplinks_settings.wan2.pppoe.authentication.enabled, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan2.pppoe.authentication.enabled, null)
            interfaces_wan2_pppoe_authentication_username   = try(device.appliance.uplinks_settings.wan2.pppoe.authentication.username, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan2.pppoe.authentication.username, null)
            interfaces_wan2_pppoe_authentication_password   = try(device.appliance.uplinks_settings.wan2.pppoe.authentication.password, local.defaults.meraki.domains.organizations.networks.devices.appliance.uplinks_settings.wan2.pppoe.authentication.password, null)
          } if try(device.appliance.uplinks_settings, null) != null
        ]
      ]
    ]
  ])
}

resource "meraki_appliance_uplinks_settings" "devices_appliance_uplinks_settings" {
  for_each                                        = { for v in local.devices_appliance_uplinks_settings : v.key => v }
  serial                                          = each.value.serial
  interfaces_wan1_enabled                         = each.value.interfaces_wan1_enabled
  interfaces_wan1_vlan_tagging_enabled            = each.value.interfaces_wan1_vlan_tagging_enabled
  interfaces_wan1_vlan_tagging_vlan_id            = each.value.interfaces_wan1_vlan_tagging_vlan_id
  interfaces_wan1_svis_ipv4_assignment_mode       = each.value.interfaces_wan1_svis_ipv4_assignment_mode
  interfaces_wan1_svis_ipv4_address               = each.value.interfaces_wan1_svis_ipv4_address
  interfaces_wan1_svis_ipv4_gateway               = each.value.interfaces_wan1_svis_ipv4_gateway
  interfaces_wan1_svis_ipv4_nameservers_addresses = each.value.interfaces_wan1_svis_ipv4_nameservers_addresses
  interfaces_wan1_svis_ipv6_assignment_mode       = each.value.interfaces_wan1_svis_ipv6_assignment_mode
  interfaces_wan1_svis_ipv6_address               = each.value.interfaces_wan1_svis_ipv6_address
  interfaces_wan1_svis_ipv6_gateway               = each.value.interfaces_wan1_svis_ipv6_gateway
  interfaces_wan1_svis_ipv6_nameservers_addresses = each.value.interfaces_wan1_svis_ipv6_nameservers_addresses
  interfaces_wan1_pppoe_enabled                   = each.value.interfaces_wan1_pppoe_enabled
  interfaces_wan1_pppoe_authentication_enabled    = each.value.interfaces_wan1_pppoe_authentication_enabled
  interfaces_wan1_pppoe_authentication_username   = each.value.interfaces_wan1_pppoe_authentication_username
  interfaces_wan1_pppoe_authentication_password   = each.value.interfaces_wan1_pppoe_authentication_password
  interfaces_wan2_enabled                         = each.value.interfaces_wan2_enabled
  interfaces_wan2_vlan_tagging_enabled            = each.value.interfaces_wan2_vlan_tagging_enabled
  interfaces_wan2_vlan_tagging_vlan_id            = each.value.interfaces_wan2_vlan_tagging_vlan_id
  interfaces_wan2_svis_ipv4_assignment_mode       = each.value.interfaces_wan2_svis_ipv4_assignment_mode
  interfaces_wan2_svis_ipv4_address               = each.value.interfaces_wan2_svis_ipv4_address
  interfaces_wan2_svis_ipv4_gateway               = each.value.interfaces_wan2_svis_ipv4_gateway
  interfaces_wan2_svis_ipv4_nameservers_addresses = each.value.interfaces_wan2_svis_ipv4_nameservers_addresses
  interfaces_wan2_svis_ipv6_assignment_mode       = each.value.interfaces_wan2_svis_ipv6_assignment_mode
  interfaces_wan2_svis_ipv6_address               = each.value.interfaces_wan2_svis_ipv6_address
  interfaces_wan2_svis_ipv6_gateway               = each.value.interfaces_wan2_svis_ipv6_gateway
  interfaces_wan2_svis_ipv6_nameservers_addresses = each.value.interfaces_wan2_svis_ipv6_nameservers_addresses
  interfaces_wan2_pppoe_enabled                   = each.value.interfaces_wan2_pppoe_enabled
  interfaces_wan2_pppoe_authentication_enabled    = each.value.interfaces_wan2_pppoe_authentication_enabled
  interfaces_wan2_pppoe_authentication_username   = each.value.interfaces_wan2_pppoe_authentication_username
  interfaces_wan2_pppoe_authentication_password   = each.value.interfaces_wan2_pppoe_authentication_password
}

locals {
  devices_management_interface = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for device in try(network.devices, []) : {
            key                     = format("%s/%s/%s/%s", domain.name, organization.name, network.name, device.name)
            serial                  = meraki_device.devices[format("%s/%s/%s/%s", domain.name, organization.name, network.name, device.name)].serial
            wan1_wan_enabled        = try(device.management_interface.wan1.wan, local.defaults.meraki.domains.organizations.networks.devices.management_interface.wan1.wan, null)
            wan1_using_static_ip    = try(device.management_interface.wan1.using_static_ip, local.defaults.meraki.domains.organizations.networks.devices.management_interface.wan1.using_static_ip, null)
            wan1_static_ip          = try(device.management_interface.wan1.static_ip, local.defaults.meraki.domains.organizations.networks.devices.management_interface.wan1.static_ip, null)
            wan1_static_gateway_ip  = try(device.management_interface.wan1.static_gateway_ip, local.defaults.meraki.domains.organizations.networks.devices.management_interface.wan1.static_gateway_ip, null)
            wan1_static_subnet_mask = try(device.management_interface.wan1.static_subnet_mask, local.defaults.meraki.domains.organizations.networks.devices.management_interface.wan1.static_subnet_mask, null)
            wan1_static_dns         = try(device.management_interface.wan1.static_dns, local.defaults.meraki.domains.organizations.networks.devices.management_interface.wan1.static_dns, null)
            wan1_vlan               = try(device.management_interface.wan1.vlan, local.defaults.meraki.domains.organizations.networks.devices.management_interface.wan1.vlan, null)
            wan2_wan_enabled        = try(device.management_interface.wan2.wan, local.defaults.meraki.domains.organizations.networks.devices.management_interface.wan2.wan, null)
            wan2_using_static_ip    = try(device.management_interface.wan2.using_static_ip, local.defaults.meraki.domains.organizations.networks.devices.management_interface.wan2.using_static_ip, null)
            wan2_static_ip          = try(device.management_interface.wan2.static_ip, local.defaults.meraki.domains.organizations.networks.devices.management_interface.wan2.static_ip, null)
            wan2_static_gateway_ip  = try(device.management_interface.wan2.static_gateway_ip, local.defaults.meraki.domains.organizations.networks.devices.management_interface.wan2.static_gateway_ip, null)
            wan2_static_subnet_mask = try(device.management_interface.wan2.static_subnet_mask, local.defaults.meraki.domains.organizations.networks.devices.management_interface.wan2.static_subnet_mask, null)
            wan2_static_dns         = try(device.management_interface.wan2.static_dns, local.defaults.meraki.domains.organizations.networks.devices.management_interface.wan2.static_dns, null)
            wan2_vlan               = try(device.management_interface.wan2.vlan, local.defaults.meraki.domains.organizations.networks.devices.management_interface.wan2.vlan, null)
          } if try(device.management_interface, null) != null
        ]
      ]
    ]
  ])
}

resource "meraki_device_management_interface" "devices_management_interface" {
  for_each                = { for v in local.devices_management_interface : v.key => v }
  serial                  = each.value.serial
  wan1_wan_enabled        = each.value.wan1_wan_enabled
  wan1_using_static_ip    = each.value.wan1_using_static_ip
  wan1_static_ip          = each.value.wan1_static_ip
  wan1_static_gateway_ip  = each.value.wan1_static_gateway_ip
  wan1_static_subnet_mask = each.value.wan1_static_subnet_mask
  wan1_static_dns         = each.value.wan1_static_dns
  wan1_vlan               = each.value.wan1_vlan
  wan2_wan_enabled        = each.value.wan2_wan_enabled
  wan2_using_static_ip    = each.value.wan2_using_static_ip
  wan2_static_ip          = each.value.wan2_static_ip
  wan2_static_gateway_ip  = each.value.wan2_static_gateway_ip
  wan2_static_subnet_mask = each.value.wan2_static_subnet_mask
  wan2_static_dns         = each.value.wan2_static_dns
  wan2_vlan               = each.value.wan2_vlan
}

locals {
  devices_switch_ports = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for device in try(network.devices, []) : {
            organization_id = local.organization_ids[format("%s/%s", domain.name, organization.name)]
            key             = format("%s/%s/%s/%s", domain.name, organization.name, network.name, device.name)
            device_serial   = meraki_device.devices[format("%s/%s/%s/%s", domain.name, organization.name, network.name, device.name)].serial
            ports = [
              for switch_port in try(device.switch.ports, []) : {
                port_ids = flatten([for port_id_range in switch_port.port_id_ranges : [
                  for port_id in range(port_id_range.from, port_id_range.to + 1) : port_id
                ]])
                data                     = switch_port
                access_policy_number     = try(meraki_switch_access_policy.networks_switch_access_policies[format("%s/%s/%s/%s", domain.name, organization.name, network.name, switch_port.access_policy_name)].id, null)
                port_schedule_id         = try(meraki_switch_port_schedule.networks_switch_port_schedules[format("%s/%s/%s/%s", domain.name, organization.name, network.name, switch_port.port_schedule_name)].id, null)
                adaptive_policy_group_id = try(meraki_organization_adaptive_policy_group.organizations_adaptive_policy_groups[format("%s/%s/%s", domain.name, organization.name, switch_port.adaptive_policy_group_name)].id, null)
              }
            ]
          } if try(device.switch.ports, null) != null
        ]
      ]
    ]
  ])
}

resource "meraki_switch_ports" "devices_switch_ports" {
  for_each        = { for v in local.devices_switch_ports : v.key => v }
  organization_id = each.value.organization_id
  serial          = each.value.device_serial
  items = flatten([
    for ports in each.value.ports : [
      for port_id in ports.port_ids : {
        port_id                     = port_id
        name                        = try(ports.data.name, local.defaults.meraki.domains.organizations.networks.devices.switch.ports.name, null)
        tags                        = try(ports.data.tags, local.defaults.meraki.domains.organizations.networks.devices.switch.ports.tags, null)
        enabled                     = try(ports.data.enabled, local.defaults.meraki.domains.organizations.networks.devices.switch.ports.enabled, null)
        poe_enabled                 = try(ports.data.poe, local.defaults.meraki.domains.organizations.networks.switch.ports.poe, null)
        type                        = try(ports.data.type, local.defaults.meraki.domains.organizations.networks.devices.switch.ports.type, null)
        vlan                        = try(ports.data.vlan, local.defaults.meraki.domains.organizations.networks.devices.switch.ports.vlan, null)
        voice_vlan                  = try(ports.data.voice_vlan, local.defaults.meraki.domains.organizations.networks.devices.switch.ports.voice_vlan, null)
        allowed_vlans               = try(ports.data.allowed_vlans, local.defaults.meraki.domains.organizations.networks.devices.switch.ports.allowed_vlans, null)
        isolation_enabled           = try(ports.data.isolation, local.defaults.meraki.domains.organizations.networks.switch.ports.isolation, null)
        rstp_enabled                = try(ports.data.rstp, local.defaults.meraki.domains.organizations.networks.switch.ports.rstp, null)
        stp_guard                   = try(ports.data.stp_guard, local.defaults.meraki.domains.organizations.networks.devices.switch.ports.stp_guard, null)
        link_negotiation            = try(ports.data.link_negotiation, local.defaults.meraki.domains.organizations.networks.devices.switch.ports.link_negotiation, null)
        port_schedule_id            = ports.port_schedule_id
        udld                        = try(ports.data.udld, local.defaults.meraki.domains.organizations.networks.devices.switch.ports.udld, null)
        access_policy_type          = try(ports.data.access_policy_type, local.defaults.meraki.domains.organizations.networks.devices.switch.ports.access_policy_type, null)
        access_policy_number        = ports.access_policy_number
        mac_allow_list              = try(ports.data.mac_allow_list, local.defaults.meraki.domains.organizations.networks.devices.switch.ports.mac_allow_list, null)
        sticky_mac_allow_list       = try(ports.data.sticky_mac_allow_list, local.defaults.meraki.domains.organizations.networks.devices.switch.ports.sticky_mac_allow_list, null)
        sticky_mac_allow_list_limit = try(ports.data.sticky_mac_allow_list_limit, local.defaults.meraki.domains.organizations.networks.devices.switch.ports.sticky_mac_allow_list_limit, null)
        storm_control_enabled       = try(ports.data.storm_control, local.defaults.meraki.domains.organizations.networks.switch.ports.storm_control, null)
        adaptive_policy_group_id    = ports.adaptive_policy_group_id
        peer_sgt_capable            = try(ports.data.peer_sgt_capable, local.defaults.meraki.domains.organizations.networks.devices.switch.ports.peer_sgt_capable, null)
        flexible_stacking_enabled   = try(ports.data.flexible_stacking, local.defaults.meraki.domains.organizations.networks.switch.ports.flexible_stacking, null)
        dai_trusted                 = try(ports.data.dai_trusted, local.defaults.meraki.domains.organizations.networks.devices.switch.ports.dai_trusted, null)
        profile_enabled             = try(ports.data.profile.enabled, local.defaults.meraki.domains.organizations.networks.devices.switch.ports.profile.enabled, null)
        # profile_id                  = try(ports.data.profile.id, local.defaults.meraki.domains.organizations.networks.devices.switch.ports.profile.id, null)
        profile_iname  = try(ports.data.profile.iname, local.defaults.meraki.domains.organizations.networks.devices.switch.ports.profile.iname, null)
        dot3az_enabled = try(ports.data.dot3az, local.defaults.meraki.domains.organizations.networks.devices.switch.ports.dot3az, null)
      }
    ]
  ])
  depends_on = [
    meraki_organization_adaptive_policy_settings.organizations_adaptive_policy_settings_enabled_networks,
  ]
}

locals {
  devices_switch_routing_interfaces = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for device in try(network.devices, []) : [
            for switch_routing_interface in try(device.switch_routing_interfaces, []) : {
              key                              = format("%s/%s/%s/%s/%s", domain.name, organization.name, network.name, device.name, switch_routing_interface.name)
              serial                           = meraki_device.devices[format("%s/%s/%s/%s", domain.name, organization.name, network.name, device.name)].serial
              name                             = try(switch_routing_interface.name, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.name, null)
              subnet                           = try(switch_routing_interface.subnet, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.subnet, null)
              interface_ip                     = try(switch_routing_interface.interface_ip, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.interface_ip, null)
              multicast_routing                = try(switch_routing_interface.multicast_routing, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.multicast_routing, null)
              vlan_id                          = try(switch_routing_interface.vlan_id, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.vlan_id, null)
              default_gateway                  = try(switch_routing_interface.default_gateway, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.default_gateway, null)
              ospf_settings_area               = try(switch_routing_interface.ospf_settings.area, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.ospf_settings.area, null)
              ospf_settings_cost               = try(switch_routing_interface.ospf_settings.cost, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.ospf_settings.cost, null)
              ospf_settings_is_passive_enabled = try(switch_routing_interface.ospf_settings.is_passive, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.ospf_settings.is_passive, null)
              ipv6_assignment_mode             = try(switch_routing_interface.ipv6.assignment_mode, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.ipv6.assignment_mode, null)
              ipv6_prefix                      = try(switch_routing_interface.ipv6.prefix, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.ipv6.prefix, null)
              ipv6_address                     = try(switch_routing_interface.ipv6.address, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.ipv6.address, null)
              ipv6_gateway                     = try(switch_routing_interface.ipv6.gateway, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.ipv6.gateway, null)
            }
          ]
        ]
      ]
    ]
  ])
}

resource "meraki_switch_routing_interface" "devices_switch_routing_interfaces" {
  for_each                         = { for v in local.devices_switch_routing_interfaces : v.key => v }
  serial                           = each.value.serial
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
}

locals {
  devices_switch_routing_interfaces_dhcp = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for device in try(network.devices, []) : [
            for switch_routing_interface in try(device.switch_routing_interfaces, []) : {
              key                    = format("%s/%s/%s/%s/%s", domain.name, organization.name, network.name, device.name, switch_routing_interface.name)
              serial                 = meraki_device.devices[format("%s/%s/%s/%s", domain.name, organization.name, network.name, device.name)].serial
              interface_id           = meraki_switch_routing_interface.devices_switch_routing_interfaces[format("%s/%s/%s/%s/%s", domain.name, organization.name, network.name, device.name, switch_routing_interface.name)].id
              dhcp_mode              = try(switch_routing_interface.dhcp.dhcp_mode, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.dhcp.dhcp_mode, null)
              dhcp_relay_server_ips  = try(switch_routing_interface.dhcp.dhcp_relay_server_ips, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.dhcp.dhcp_relay_server_ips, null)
              dhcp_lease_time        = try(switch_routing_interface.dhcp.dhcp_lease_time, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.dhcp.dhcp_lease_time, null)
              dns_nameservers_option = try(switch_routing_interface.dhcp.dns_nameservers_option, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.dhcp.dns_nameservers_option, null)
              dns_custom_nameservers = try(switch_routing_interface.dhcp.dns_custom_nameservers, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.dhcp.dns_custom_nameservers, null)
              boot_options_enabled   = try(switch_routing_interface.dhcp.boot_options, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.dhcp.boot_options, null)
              boot_next_server       = try(switch_routing_interface.dhcp.boot_next_server, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.dhcp.boot_next_server, null)
              boot_file_name         = try(switch_routing_interface.dhcp.boot_file_name, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.dhcp.boot_file_name, null)
              dhcp_options = try(switch_routing_interface.dhcp.dhcp_options, null) == null ? null : [
                for dhcp_option in try(switch_routing_interface.dhcp.dhcp_options, []) : {
                  code  = try(dhcp_option.code, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.dhcp.dhcp_options.code, null)
                  type  = try(dhcp_option.type, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.dhcp.dhcp_options.type, null)
                  value = try(dhcp_option.value, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.dhcp.dhcp_options.value, null)
                }
              ]
              reserved_ip_ranges = try(switch_routing_interface.dhcp.reserved_ip_ranges, null) == null ? null : [
                for reserved_ip_range in try(switch_routing_interface.dhcp.reserved_ip_ranges, []) : {
                  start   = try(reserved_ip_range.start, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.dhcp.reserved_ip_ranges.start, null)
                  end     = try(reserved_ip_range.end, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.dhcp.reserved_ip_ranges.end, null)
                  comment = try(reserved_ip_range.comment, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.dhcp.reserved_ip_ranges.comment, null)
                }
              ]
              fixed_ip_assignments = try(switch_routing_interface.dhcp.fixed_ip_assignments, null) == null ? null : [
                for fixed_ip_assignment in try(switch_routing_interface.dhcp.fixed_ip_assignments, []) : {
                  name = try(fixed_ip_assignment.name, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.dhcp.fixed_ip_assignments.name, null)
                  mac  = try(fixed_ip_assignment.mac, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.dhcp.fixed_ip_assignments.mac, null)
                  ip   = try(fixed_ip_assignment.ip, local.defaults.meraki.domains.organizations.networks.devices.switch_routing_interfaces.dhcp.fixed_ip_assignments.ip, null)
                }
              ]
            } if try(switch_routing_interface.dhcp, null) != null
          ]
        ]
      ]
    ]
  ])
}

resource "meraki_switch_routing_interface_dhcp" "devices_switch_routing_interfaces_dhcp" {
  for_each               = { for v in local.devices_switch_routing_interfaces_dhcp : v.key => v }
  serial                 = each.value.serial
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
  devices_switch_routing_static_routes = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for device in try(network.devices, []) : [
            for switch_routing_static_route in try(device.switch.routing_static_routes, []) : {
              key                             = format("%s/%s/%s/%s/%s", domain.name, organization.name, network.name, device.name, switch_routing_static_route.name)
              serial                          = meraki_device.devices[format("%s/%s/%s/%s", domain.name, organization.name, network.name, device.name)].serial
              name                            = try(switch_routing_static_route.name, local.defaults.meraki.domains.organizations.networks.devices.switch.routing_static_routes.name, null)
              subnet                          = try(switch_routing_static_route.subnet, local.defaults.meraki.domains.organizations.networks.devices.switch.routing_static_routes.subnet, null)
              next_hop_ip                     = try(switch_routing_static_route.next_hop_ip, local.defaults.meraki.domains.organizations.networks.devices.switch.routing_static_routes.next_hop_ip, null)
              advertise_via_ospf_enabled      = try(switch_routing_static_route.advertise_via_ospf, local.defaults.meraki.domains.organizations.networks.devices.switch.routing_static_routes.advertise_via_ospf, null)
              prefer_over_ospf_routes_enabled = try(switch_routing_static_route.prefer_over_ospf_routes, local.defaults.meraki.domains.organizations.networks.devices.switch.routing_static_routes.prefer_over_ospf_routes, null)
            }
          ]
        ]
      ]
    ]
  ])
}

resource "meraki_switch_routing_static_route" "devices_switch_routing_static_routes" {
  for_each                        = { for v in local.devices_switch_routing_static_routes : v.key => v }
  serial                          = each.value.serial
  name                            = each.value.name
  subnet                          = each.value.subnet
  next_hop_ip                     = each.value.next_hop_ip
  advertise_via_ospf_enabled      = each.value.advertise_via_ospf_enabled
  prefer_over_ospf_routes_enabled = each.value.prefer_over_ospf_routes_enabled
  depends_on = [
    meraki_switch_routing_interface.devices_switch_routing_interfaces,
  ]
}

locals {
  devices_wireless_bluetooth_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for device in try(network.devices, []) : {
            key    = format("%s/%s/%s/%s", domain.name, organization.name, network.name, device.name)
            serial = meraki_device.devices[format("%s/%s/%s/%s", domain.name, organization.name, network.name, device.name)].serial
            uuid   = try(device.wireless.bluetooth_settings.uuid, local.defaults.meraki.domains.organizations.networks.devices.wireless.bluetooth_settings.uuid, null)
            major  = try(device.wireless.bluetooth_settings.major, local.defaults.meraki.domains.organizations.networks.devices.wireless.bluetooth_settings.major, null)
            minor  = try(device.wireless.bluetooth_settings.minor, local.defaults.meraki.domains.organizations.networks.devices.wireless.bluetooth_settings.minor, null)
          } if try(device.wireless.bluetooth_settings, null) != null
        ]
      ]
    ]
  ])
}

resource "meraki_wireless_device_bluetooth_settings" "devices_wireless_bluetooth_settings" {
  for_each = { for v in local.devices_wireless_bluetooth_settings : v.key => v }
  serial   = each.value.serial
  uuid     = each.value.uuid
  major    = each.value.major
  minor    = each.value.minor
}

locals {
  devices_cellular_gateway_lan = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for device in try(network.devices, []) : {
            key    = format("%s/%s/%s/%s", domain.name, organization.name, network.name, device.name)
            serial = meraki_device.devices[format("%s/%s/%s/%s", domain.name, organization.name, network.name, device.name)].serial
            reserved_ip_ranges = [
              for reserved_ip_range in try(device.cellular_gateway.lan.reserved_ip_ranges, []) : {
                start   = try(reserved_ip_range.start, local.defaults.meraki.domains.organizations.networks.devices.cellular_gateway.lan.reserved_ip_ranges.start, null)
                end     = try(reserved_ip_range.end, local.defaults.meraki.domains.organizations.networks.devices.cellular_gateway.lan.reserved_ip_ranges.end, null)
                comment = try(reserved_ip_range.comment, local.defaults.meraki.domains.organizations.networks.devices.cellular_gateway.lan.reserved_ip_ranges.comment, null)
              }
            ]
            fixed_ip_assignments = [
              for fixed_ip_assignment in try(device.cellular_gateway.lan.fixed_ip_assignments, []) : {
                name = try(fixed_ip_assignment.name, local.defaults.meraki.domains.organizations.networks.devices.cellular_gateway.lan.fixed_ip_assignments.name, null)
                ip   = try(fixed_ip_assignment.ip, local.defaults.meraki.domains.organizations.networks.devices.cellular_gateway.lan.fixed_ip_assignments.ip, null)
                mac  = try(fixed_ip_assignment.mac, local.defaults.meraki.domains.organizations.networks.devices.cellular_gateway.lan.fixed_ip_assignments.mac, null)
              }
            ]
          } if try(device.cellular_gateway.lan, null) != null
        ]
      ]
    ]
  ])
}

resource "meraki_cellular_gateway_lan" "devices_cellular_gateway_lan" {
  for_each             = { for v in local.devices_cellular_gateway_lan : v.key => v }
  serial               = each.value.serial
  reserved_ip_ranges   = each.value.reserved_ip_ranges
  fixed_ip_assignments = each.value.fixed_ip_assignments
}

locals {
  devices_cellular_gateway_port_forwarding_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for device in try(network.devices, []) : {
            key    = format("%s/%s/%s/%s", domain.name, organization.name, network.name, device.name)
            serial = meraki_device.devices[format("%s/%s/%s/%s", domain.name, organization.name, network.name, device.name)].serial
            rules = [
              for cellular_gateway_port_forwarding_rule in try(device.cellular_gateway.port_forwarding_rules, []) : {
                name        = try(cellular_gateway_port_forwarding_rule.name, local.defaults.meraki.domains.organizations.networks.devices.cellular_gateway.port_forwarding_rules.name, null)
                lan_ip      = try(cellular_gateway_port_forwarding_rule.lan_ip, local.defaults.meraki.domains.organizations.networks.devices.cellular_gateway.port_forwarding_rules.lan_ip, null)
                public_port = try(cellular_gateway_port_forwarding_rule.public_port, local.defaults.meraki.domains.organizations.networks.devices.cellular_gateway.port_forwarding_rules.public_port, null)
                local_port  = try(cellular_gateway_port_forwarding_rule.local_port, local.defaults.meraki.domains.organizations.networks.devices.cellular_gateway.port_forwarding_rules.local_port, null)
                allowed_ips = try(cellular_gateway_port_forwarding_rule.allowed_ips, local.defaults.meraki.domains.organizations.networks.devices.cellular_gateway.port_forwarding_rules.allowed_ips, null)
                protocol    = try(cellular_gateway_port_forwarding_rule.protocol, local.defaults.meraki.domains.organizations.networks.devices.cellular_gateway.port_forwarding_rules.protocol, null)
                access      = try(cellular_gateway_port_forwarding_rule.access, local.defaults.meraki.domains.organizations.networks.devices.cellular_gateway.port_forwarding_rules.access, null)
              }
            ]
          } if try(device.cellular_gateway.port_forwarding_rules, null) != null
        ]
      ]
    ]
  ])
}

resource "meraki_cellular_gateway_port_forwarding_rules" "devices_cellular_gateway_port_forwarding_rules" {
  for_each = { for v in local.devices_cellular_gateway_port_forwarding_rules : v.key => v }
  serial   = each.value.serial
  rules    = each.value.rules
}

locals {
  devices_cellular_sims = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for device in try(network.devices, []) : {
            key    = format("%s/%s/%s/%s", domain.name, organization.name, network.name, device.name)
            serial = meraki_device.devices[format("%s/%s/%s/%s", domain.name, organization.name, network.name, device.name)].serial
            sims = try(device.cellular_sims.sims, null) == null ? null : [
              for sim in try(device.cellular_sims.sims, []) : {
                slot       = try(sim.slot, local.defaults.meraki.domains.organizations.networks.devices.cellular_sims.sims.slot, null)
                is_primary = try(sim.is_primary, local.defaults.meraki.domains.organizations.networks.devices.cellular_sims.sims.is_primary, null)
                apns = try(sim.apns, null) == null ? null : [
                  for apn in try(sim.apns, []) : {
                    name                    = try(apn.name, local.defaults.meraki.domains.organizations.networks.devices.cellular_sims.sims.apns.name, null)
                    allowed_ip_types        = try(apn.allowed_ip_types, local.defaults.meraki.domains.organizations.networks.devices.cellular_sims.sims.apns.allowed_ip_types, null)
                    authentication_type     = try(apn.authentication.type, local.defaults.meraki.domains.organizations.networks.devices.cellular_sims.sims.apns.authentication.type, null)
                    authentication_username = try(apn.authentication.username, local.defaults.meraki.domains.organizations.networks.devices.cellular_sims.sims.apns.authentication.username, null)
                    authentication_password = try(apn.authentication.password, local.defaults.meraki.domains.organizations.networks.devices.cellular_sims.sims.apns.authentication.password, null)
                  }
                ]
                sim_order = try(sim.sim_order, local.defaults.meraki.domains.organizations.networks.devices.cellular_sims.sims.sim_order, null)
              }
            ]
            sim_ordering         = try(device.cellular_sims.sim_ordering, local.defaults.meraki.domains.organizations.networks.devices.cellular_sims.sim_ordering, null)
            sim_failover_enabled = try(device.cellular_sims.sim_failover.enabled, local.defaults.meraki.domains.organizations.networks.devices.cellular_sims.sim_failover.enabled, null)
            sim_failover_timeout = try(device.cellular_sims.sim_failover.timeout, local.defaults.meraki.domains.organizations.networks.devices.cellular_sims.sim_failover.timeout, null)
          } if try(device.cellular_sims, null) != null
        ]
      ]
    ]
  ])
}

resource "meraki_device_cellular_sims" "devices_cellular_sims" {
  for_each             = { for v in local.devices_cellular_sims : v.key => v }
  serial               = each.value.serial
  sims                 = each.value.sims
  sim_ordering         = each.value.sim_ordering
  sim_failover_enabled = each.value.sim_failover_enabled
  sim_failover_timeout = each.value.sim_failover_timeout
}
