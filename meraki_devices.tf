locals {
  devices = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for device in try(network.devices, []) : {
            key  = format("%s/%s/%s", domain.name, organization.name, device.name)
            data = device
          }
        ]
      ]
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_device" "device" {
  for_each = { for dev in local.devices : dev.key => dev }
  serial   = each.value.data.serial

  name            = try(each.value.data.name, local.defaults.meraki.devices.name, null)
  tags            = try(each.value.data.tags, local.defaults.meraki.devices.tags, null)
  lat             = try(each.value.data.lat, local.defaults.meraki.devices.lat, null)
  lng             = try(each.value.data.lng, local.defaults.meraki.devices.lng, null)
  address         = try(each.value.data.address, local.defaults.meraki.devices.address, null)
  notes           = try(each.value.data.notes, local.defaults.meraki.devices.notes, null)
  move_map_marker = try(each.value.data.move_map_marker, local.defaults.meraki.devices.move_map_marker, null)
  #   switch_profile_id = try(each.value.data.switch_profile_id, local.defaults.meraki.devices.switch_profile_id, null)
  #   floor_plan_id = try(each.value.data.floor_plan_id, local.defaults.meraki.devices.floor_plan_id, null)

}

locals {
  devices_appliance_uplinks_settings = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for device in try(network.devices, []) : {
            device_serial = meraki_device.device["${domain.name}/${organization.name}/${device.name}"].serial

            data = try(device.appliance_uplinks_settings, null)
          } if try(device.appliance_uplinks_settings, null) != null
        ]
      ]
    ]
  ])
}

resource "meraki_appliance_uplinks_settings" "devices_appliance_uplinks_settings" {
  for_each = { for i, v in local.devices_appliance_uplinks_settings : i => v }
  serial   = each.value.device_serial

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
            device_serial = meraki_device.device["${domain.name}/${organization.name}/${device.name}"].serial

            data = try(device.management_interface, null)
          } if try(device.management_interface, null) != null
        ]
      ]
    ]
  ])
}

resource "meraki_device_management_interface" "devices_management_interface" {
  for_each = { for i, v in local.devices_management_interface : i => v }
  serial   = each.value.device_serial

  wan1_wan_enabled        = try(each.value.data.wan1.wan_enabled, local.defaults.meraki.networks.devices_management_interface.wan1.wan_enabled, null)
  wan1_using_static_ip    = try(each.value.data.wan1.using_static_ip, local.defaults.meraki.networks.devices_management_interface.wan1.using_static_ip, null)
  wan1_static_ip          = try(each.value.data.wan1.static_ip, local.defaults.meraki.networks.devices_management_interface.wan1.static_ip, null)
  wan1_static_gateway_ip  = try(each.value.data.wan1.static_gateway_ip, local.defaults.meraki.networks.devices_management_interface.wan1.static_gateway_ip, null)
  wan1_static_subnet_mask = try(each.value.data.wan1.static_subnet_mask, local.defaults.meraki.networks.devices_management_interface.wan1.static_subnet_mask, null)
  wan1_static_dns         = try(each.value.data.wan1.static_dns, local.defaults.meraki.networks.devices_management_interface.wan1.static_dns, null)
  wan1_vlan               = try(each.value.data.wan1.vlan, local.defaults.meraki.networks.devices_management_interface.wan1.vlan, null)
  wan2_wan_enabled        = try(each.value.data.wan2.wan_enabled, local.defaults.meraki.networks.devices_management_interface.wan2.wan_enabled, null)
  wan2_using_static_ip    = try(each.value.data.wan2.using_static_ip, local.defaults.meraki.networks.devices_management_interface.wan2.using_static_ip, null)
  wan2_static_ip          = try(each.value.data.wan2.static_ip, local.defaults.meraki.networks.devices_management_interface.wan2.static_ip, null)
  wan2_static_gateway_ip  = try(each.value.data.wan2.static_gateway_ip, local.defaults.meraki.networks.devices_management_interface.wan2.static_gateway_ip, null)
  wan2_static_subnet_mask = try(each.value.data.wan2.static_subnet_mask, local.defaults.meraki.networks.devices_management_interface.wan2.static_subnet_mask, null)
  wan2_static_dns         = try(each.value.data.wan2.static_dns, local.defaults.meraki.networks.devices_management_interface.wan2.static_dns, null)
  wan2_vlan               = try(each.value.data.wan2.vlan, local.defaults.meraki.networks.devices_management_interface.wan2.vlan, null)

}

locals {
  devices_switch_ports = flatten([

    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for device in try(network.devices, []) : [
            for switch_port in try(device.switch_ports, []) : {
              device_serial = meraki_device.device["${domain.name}/${organization.name}/${device.name}"].serial

              data = switch_port
            }
          ] if try(device.switch_ports, null) != null
        ]
      ]
    ]
  ])
}

resource "meraki_switch_port" "devices_switch_ports" {
  for_each = { for i, v in local.devices_switch_ports : i => v }
  serial   = each.value.device_serial
  port_id  = each.value.data.port_id

  name                        = try(each.value.data.name, local.defaults.meraki.networks.devices_switch_ports.name, null)
  tags                        = try(each.value.data.tags, local.defaults.meraki.networks.devices_switch_ports.tags, null)
  enabled                     = try(each.value.data.enabled, local.defaults.meraki.networks.devices_switch_ports.enabled, null)
  poe_enabled                 = try(each.value.data.poe_enabled, local.defaults.meraki.networks.devices_switch_ports.poe_enabled, null)
  type                        = try(each.value.data.type, local.defaults.meraki.networks.devices_switch_ports.type, null)
  vlan                        = try(each.value.data.vlan, local.defaults.meraki.networks.devices_switch_ports.vlan, null)
  voice_vlan                  = try(each.value.data.voice_vlan, local.defaults.meraki.networks.devices_switch_ports.voice_vlan, null)
  allowed_vlans               = try(each.value.data.allowed_vlans, local.defaults.meraki.networks.devices_switch_ports.allowed_vlans, null)
  isolation_enabled           = try(each.value.data.isolation_enabled, local.defaults.meraki.networks.devices_switch_ports.isolation_enabled, null)
  rstp_enabled                = try(each.value.data.rstp_enabled, local.defaults.meraki.networks.devices_switch_ports.rstp_enabled, null)
  stp_guard                   = try(each.value.data.stp_guard, local.defaults.meraki.networks.devices_switch_ports.stp_guard, null)
  link_negotiation            = try(each.value.data.link_negotiation, local.defaults.meraki.networks.devices_switch_ports.link_negotiation, null)
  port_schedule_id            = try(each.value.data.port_schedule_id, local.defaults.meraki.networks.devices_switch_ports.port_schedule_id, null)
  udld                        = try(each.value.data.udld, local.defaults.meraki.networks.devices_switch_ports.udld, null)
  access_policy_type          = try(each.value.data.access_policy_type, local.defaults.meraki.networks.devices_switch_ports.access_policy_type, null)
  access_policy_number        = try(each.value.data.access_policy_number, local.defaults.meraki.networks.devices_switch_ports.access_policy_number, null)
  mac_allow_list              = try(each.value.data.mac_allow_list, local.defaults.meraki.networks.devices_switch_ports.mac_allow_list, null)
  sticky_mac_allow_list       = try(each.value.data.sticky_mac_allow_list, local.defaults.meraki.networks.devices_switch_ports.sticky_mac_allow_list, null)
  sticky_mac_allow_list_limit = try(each.value.data.sticky_mac_allow_list_limit, local.defaults.meraki.networks.devices_switch_ports.sticky_mac_allow_list_limit, null)
  storm_control_enabled       = try(each.value.data.storm_control_enabled, local.defaults.meraki.networks.devices_switch_ports.storm_control_enabled, null)
  adaptive_policy_group_id    = try(each.value.data.adaptive_policy_group_id, local.defaults.meraki.networks.devices_switch_ports.adaptive_policy_group_id, null)
  peer_sgt_capable            = try(each.value.data.peer_sgt_capable, local.defaults.meraki.networks.devices_switch_ports.peer_sgt_capable, null)
  flexible_stacking_enabled   = try(each.value.data.flexible_stacking_enabled, local.defaults.meraki.networks.devices_switch_ports.flexible_stacking_enabled, null)
  dai_trusted                 = try(each.value.data.dai_trusted, local.defaults.meraki.networks.devices_switch_ports.dai_trusted, null)
  profile_enabled             = try(each.value.data.profile.enabled, local.defaults.meraki.networks.devices_switch_ports.profile.enabled, null)
  profile_id                  = try(each.value.data.profile.id, local.defaults.meraki.networks.devices_switch_ports.profile.id, null)
  profile_iname               = try(each.value.data.profile.iname, local.defaults.meraki.networks.devices_switch_ports.profile.iname, null)
  dot3az_enabled              = try(each.value.data.dot3az.enabled, local.defaults.meraki.networks.devices_switch_ports.dot3az.enabled, null)

}
