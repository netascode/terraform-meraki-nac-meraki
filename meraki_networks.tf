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
  marcin_debug = 5
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


### marcin generated
### resource name: switch_access_control_lists
### values: ['rules', 'rules_response']

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
  rules = try(each.value.rules, null)
  # rules_response = try(each.value.rules_response, null)
}



### marcin generated
### resource name: switch_access_policies
### values: ['access_policy_number', 'access_policy_type', 'counts', 'dot1x', 'guest_port_bouncing', 'guest_vlan_id', 'host_mode', 'increase_access_speed', 'name', 'radius', 'radius_accounting_enabled', 'radius_accounting_servers', 'radius_accounting_servers_response', 'radius_coa_support_enabled', 'radius_group_attribute', 'radius_servers', 'radius_servers_response', 'radius_testing_enabled', 'url_redirect_walled_garden_enabled', 'url_redirect_walled_garden_ranges', 'voice_vlan_clients']

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
  for_each   = { for data in local.networks_switch_access_policies : data.network_id => data.data }
  network_id = each.key
  access_policy_number = try(each.value.access_policy_number, null)
  access_policy_type = try(each.value.access_policy_type, null)
  # counts = try(each.value.counts, null)
  dot1x = try(each.value.dot1x, null)
  guest_port_bouncing = try(each.value.guest_port_bouncing, null)
  guest_vlan_id = try(each.value.guest_vlan_id, null)
  host_mode = try(each.value.host_mode, null)
  increase_access_speed = try(each.value.increase_access_speed, null)
  name = try(each.value.name, null)
  radius = try(each.value.radius, null)
  radius_accounting_enabled = try(each.value.radius_accounting_enabled, null)
  radius_accounting_servers = try(each.value.radius_accounting_servers, null)
  # radius_accounting_servers_response = try(each.value.radius_accounting_servers_response, null)
  radius_coa_support_enabled = try(each.value.radius_coa_support_enabled, null)
  radius_group_attribute = try(each.value.radius_group_attribute, null)
  radius_servers = try(each.value.radius_servers, null)
  # radius_servers_response = try(each.value.radius_servers_response, null)
  radius_testing_enabled = try(each.value.radius_testing_enabled, null)
  url_redirect_walled_garden_enabled = try(each.value.url_redirect_walled_garden_enabled, null)
  url_redirect_walled_garden_ranges = try(each.value.url_redirect_walled_garden_ranges, null)
  voice_vlan_clients = try(each.value.voice_vlan_clients, null)
}



### marcin generated
### resource name: switch_alternate_management_interface
### values: ['enabled', 'protocols', 'switches', 'vlan_id']

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
  enabled = try(each.value.enabled, null)
  protocols = try(each.value.protocols, null)
  switches = try(each.value.switches, null)
  vlan_id = try(each.value.vlan_id, null)
}



### marcin generated
### resource name: switch_dhcp_server_policy
### values: ['alerts', 'allowed_servers', 'arp_inspection', 'blocked_servers', 'default_policy']

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
  for_each   = { for data in local.networks_switch_dhcp_server_policy : data.network_id => data.data }
  network_id = each.key
  alerts = try(each.value.alerts, null)
  allowed_servers = try(each.value.allowed_servers, null)
  arp_inspection = try(each.value.arp_inspection, null)
  blocked_servers = try(each.value.blocked_servers, null)
  default_policy = try(each.value.default_policy, null)
}



### marcin generated
### resource name: switch_dhcp_server_policy_arp_inspection_trusted_servers
### values: ['ipv4', 'mac', 'trusted_server_id', 'vlan']

locals {
  networks_switch_dhcp_server_policy_arp_inspection_trusted_servers = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = network.switch_dhcp_server_policy_arp_inspection_trusted_servers
        } if try(network.switch_dhcp_server_policy_arp_inspection_trusted_servers, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_dhcp_server_policy_arp_inspection_trusted_servers" "net_switch_dhcp_server_policy_arp_inspection_trusted_servers" {
  for_each   = { for data in local.networks_switch_dhcp_server_policy_arp_inspection_trusted_servers : data.network_id => data.data }
  network_id = each.key
  ipv4 = try(each.value.ipv4, null)
  mac = try(each.value.mac, null)
  trusted_server_id = try(each.value.trusted_server_id, null)
  vlan = try(each.value.vlan, null)
}



### marcin generated
### resource name: switch_dscp_to_cos_mappings
### values: ['mappings']

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
  mappings = try(each.value.mappings, null)
}



### marcin generated
### resource name: switch_link_aggregations
### values: ['id', 'link_aggregation_id', 'switch_ports', 'switch_profile_ports']

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
  link_aggregation_id = try(each.value.link_aggregation_id, null)
  switch_ports = try(each.value.switch_ports, null)
  switch_profile_ports = try(each.value.switch_profile_ports, null)
}



### marcin generated
### resource name: switch_mtu
### values: ['default_mtu_size', 'overrides']

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
  for_each   = { for data in local.networks_switch_mtu : data.network_id => data.data }
  network_id = each.key
  default_mtu_size = try(each.value.default_mtu_size, null)
  overrides = try(each.value.overrides, null)
}



### marcin generated
### resource name: switch_port_schedules
### values: ['id', 'name', 'port_schedule', 'port_schedule_id']

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
  name = try(each.value.name, null)
  port_schedule = try(each.value.port_schedule, null)
  port_schedule_id = try(each.value.port_schedule_id, null)
}



### marcin generated
### resource name: switch_qos_rules_order
### values: ['dscp', 'dst_port', 'dst_port_range', 'id', 'protocol', 'qos_rule_id', 'src_port', 'src_port_range', 'vlan']

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
  for_each   = { for data in local.networks_switch_qos_rules_order : data.network_id => data.data }
  network_id = each.key
  dscp = try(each.value.dscp, null)
  dst_port = try(each.value.dst_port, null)
  dst_port_range = try(each.value.dst_port_range, null)
  # id = try(each.value.id, null)
  protocol = try(each.value.protocol, null)
  qos_rule_id = try(each.value.qos_rule_id, null)
  src_port = try(each.value.src_port, null)
  src_port_range = try(each.value.src_port_range, null)
  vlan = try(each.value.vlan, null)
}



### marcin generated
### resource name: switch_routing_multicast
### values: ['default_settings', 'overrides']

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
  for_each   = { for data in local.networks_switch_routing_multicast : data.network_id => data.data }
  network_id = each.key
  default_settings = try(each.value.default_settings, null)
  overrides = try(each.value.overrides, null)
}



### marcin generated
### resource name: switch_routing_multicast_rendezvous_points
### values: ['interface_ip', 'interface_name', 'multicast_group', 'rendezvous_point_id', 'serial']

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
  for_each   = { for data in local.networks_switch_routing_multicast_rendezvous_points : data.network_id => data.data }
  network_id = each.key
  interface_ip = try(each.value.interface_ip, null)
  # interface_name = try(each.value.interface_name, null)
  multicast_group = try(each.value.multicast_group, null)
  rendezvous_point_id = try(each.value.rendezvous_point_id, null)
  # serial = try(each.value.serial, null)
}



### marcin generated
### resource name: switch_routing_ospf
### values: ['areas', 'dead_timer_in_seconds', 'enabled', 'hello_timer_in_seconds', 'md5_authentication_enabled', 'md5_authentication_key', 'v3']

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
  for_each   = { for data in local.networks_switch_routing_ospf : data.network_id => data.data }
  network_id = each.key
  areas = try(each.value.areas, null)
  dead_timer_in_seconds = try(each.value.dead_timer_in_seconds, null)
  enabled = try(each.value.enabled, null)
  hello_timer_in_seconds = try(each.value.hello_timer_in_seconds, null)
  md5_authentication_enabled = try(each.value.md5_authentication_enabled, null)
  md5_authentication_key = try(each.value.md5_authentication_key, null)
  v3 = try(each.value.v3, null)
}



### marcin generated
### resource name: switch_settings
### values: ['mac_blocklist', 'power_exceptions', 'uplink_client_sampling', 'use_combined_power', 'vlan']

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
  for_each   = { for data in local.networks_switch_settings : data.network_id => data.data }
  network_id = each.key
  mac_blocklist = try(each.value.mac_blocklist, null)
  power_exceptions = try(each.value.power_exceptions, null)
  uplink_client_sampling = try(each.value.uplink_client_sampling, null)
  use_combined_power = try(each.value.use_combined_power, null)
  vlan = try(each.value.vlan, null)
}



### marcin generated
### resource name: switch_stacks
### values: ['id', 'name', 'serials', 'switch_stack_id']

locals {
  networks_switch_stacks = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = network.switch_stacks
        } if try(network.switch_stacks, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_stacks" "net_switch_stacks" {
  for_each   = { for data in local.networks_switch_stacks : data.network_id => data.data }
  network_id = each.key
  # id = try(each.value.id, null)
  name = try(each.value.name, null)
  serials = try(each.value.serials, null)
  switch_stack_id = try(each.value.switch_stack_id, null)
}



### marcin generated
### resource name: switch_stacks_add
### values: ['item', 'parameters', 'switch_stack_id']

locals {
  networks_switch_stacks_add = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = network.switch_stacks_add
        } if try(network.switch_stacks_add, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_stacks_add" "net_switch_stacks_add" {
  for_each   = { for data in local.networks_switch_stacks_add : data.network_id => data.data }
  network_id = each.key
  # item = try(each.value.item, null)
  parameters = try(each.value.parameters, null)
  switch_stack_id = try(each.value.switch_stack_id, null)
}



### marcin generated
### resource name: switch_stacks_remove
### values: ['item', 'parameters', 'switch_stack_id']

locals {
  networks_switch_stacks_remove = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = network.switch_stacks_remove
        } if try(network.switch_stacks_remove, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_stacks_remove" "net_switch_stacks_remove" {
  for_each   = { for data in local.networks_switch_stacks_remove : data.network_id => data.data }
  network_id = each.key
  # item = try(each.value.item, null)
  parameters = try(each.value.parameters, null)
  switch_stack_id = try(each.value.switch_stack_id, null)
}



### marcin generated
### resource name: switch_stacks_routing_interfaces
### values: ['default_gateway', 'interface_id', 'interface_ip', 'ipv6', 'multicast_routing', 'name', 'ospf_settings', 'ospf_v3', 'subnet', 'switch_stack_id', 'vlan_id']

locals {
  networks_switch_stacks_routing_interfaces = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = network.switch_stacks_routing_interfaces
        } if try(network.switch_stacks_routing_interfaces, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_stacks_routing_interfaces" "net_switch_stacks_routing_interfaces" {
  for_each   = { for data in local.networks_switch_stacks_routing_interfaces : data.network_id => data.data }
  network_id = each.key
  default_gateway = try(each.value.default_gateway, null)
  interface_id = try(each.value.interface_id, null)
  interface_ip = try(each.value.interface_ip, null)
  ipv6 = try(each.value.ipv6, null)
  multicast_routing = try(each.value.multicast_routing, null)
  name = try(each.value.name, null)
  ospf_settings = try(each.value.ospf_settings, null)
  # ospf_v3 = try(each.value.ospf_v3, null)
  subnet = try(each.value.subnet, null)
  switch_stack_id = try(each.value.switch_stack_id, null)
  vlan_id = try(each.value.vlan_id, null)
}



### marcin generated
### resource name: switch_stacks_routing_interfaces_dhcp
### values: ['boot_file_name', 'boot_next_server', 'boot_options_enabled', 'dhcp_lease_time', 'dhcp_mode', 'dhcp_options', 'dhcp_relay_server_ips', 'dns_custom_nameservers', 'dns_nameservers_option', 'fixed_ip_assignments', 'interface_id', 'reserved_ip_ranges', 'switch_stack_id']

locals {
  networks_switch_stacks_routing_interfaces_dhcp = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = network.switch_stacks_routing_interfaces_dhcp
        } if try(network.switch_stacks_routing_interfaces_dhcp, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_stacks_routing_interfaces_dhcp" "net_switch_stacks_routing_interfaces_dhcp" {
  for_each   = { for data in local.networks_switch_stacks_routing_interfaces_dhcp : data.network_id => data.data }
  network_id = each.key
  boot_file_name = try(each.value.boot_file_name, null)
  boot_next_server = try(each.value.boot_next_server, null)
  boot_options_enabled = try(each.value.boot_options_enabled, null)
  dhcp_lease_time = try(each.value.dhcp_lease_time, null)
  dhcp_mode = try(each.value.dhcp_mode, null)
  dhcp_options = try(each.value.dhcp_options, null)
  dhcp_relay_server_ips = try(each.value.dhcp_relay_server_ips, null)
  dns_custom_nameservers = try(each.value.dns_custom_nameservers, null)
  dns_nameservers_option = try(each.value.dns_nameservers_option, null)
  fixed_ip_assignments = try(each.value.fixed_ip_assignments, null)
  interface_id = try(each.value.interface_id, null)
  reserved_ip_ranges = try(each.value.reserved_ip_ranges, null)
  switch_stack_id = try(each.value.switch_stack_id, null)
}



### marcin generated
### resource name: switch_stacks_routing_static_routes
### values: ['advertise_via_ospf_enabled', 'name', 'next_hop_ip', 'prefer_over_ospf_routes_enabled', 'static_route_id', 'subnet', 'switch_stack_id']

locals {
  networks_switch_stacks_routing_static_routes = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          network_id = meraki_networks.networks["${domain.name}/${org.name}/${network.name}"].id
          data       = network.switch_stacks_routing_static_routes
        } if try(network.switch_stacks_routing_static_routes, null) != null
      ]
    ]
  ])
}

resource "meraki_networks_switch_stacks_routing_static_routes" "net_switch_stacks_routing_static_routes" {
  for_each   = { for data in local.networks_switch_stacks_routing_static_routes : data.network_id => data.data }
  network_id = each.key
  advertise_via_ospf_enabled = try(each.value.advertise_via_ospf_enabled, null)
  name = try(each.value.name, null)
  next_hop_ip = try(each.value.next_hop_ip, null)
  prefer_over_ospf_routes_enabled = try(each.value.prefer_over_ospf_routes_enabled, null)
  static_route_id = try(each.value.static_route_id, null)
  subnet = try(each.value.subnet, null)
  switch_stack_id = try(each.value.switch_stack_id, null)
}



### marcin generated
### resource name: switch_storm_control
### values: ['broadcast_threshold', 'multicast_threshold', 'unknown_unicast_threshold']

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
  for_each   = { for data in local.networks_switch_storm_control : data.network_id => data.data }
  network_id = each.key
  broadcast_threshold = try(each.value.broadcast_threshold, null)
  multicast_threshold = try(each.value.multicast_threshold, null)
  unknown_unicast_threshold = try(each.value.unknown_unicast_threshold, null)
}



### marcin generated
### resource name: switch_stp
### values: ['rstp_enabled', 'stp_bridge_priority', 'stp_bridge_priority_response']

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
  for_each   = { for data in local.networks_switch_stp : data.network_id => data.data }
  network_id = each.key
  rstp_enabled = try(each.value.rstp_enabled, null)
  stp_bridge_priority = try(each.value.stp_bridge_priority, null)
  # stp_bridge_priority_response = try(each.value.stp_bridge_priority_response, null)
}

