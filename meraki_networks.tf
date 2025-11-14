locals {
  networks_group_policies = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for group_policy in try(network.group_policies, []) : {
            key                                   = format("%s/%s/%s/%s", domain.name, organization.name, network.name, group_policy.name)
            network_id                            = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
            name                                  = try(group_policy.name, local.defaults.meraki.domains.organizations.networks.group_policies.name, null)
            scheduling_enabled                    = try(group_policy.scheduling.enabled, local.defaults.meraki.domains.organizations.networks.group_policies.scheduling.enabled, null)
            scheduling_monday_active              = try(group_policy.scheduling.monday.active, local.defaults.meraki.domains.organizations.networks.group_policies.scheduling.monday.active, null)
            scheduling_monday_from                = try(group_policy.scheduling.monday.from, local.defaults.meraki.domains.organizations.networks.group_policies.scheduling.monday.from, null)
            scheduling_monday_to                  = try(group_policy.scheduling.monday.to, local.defaults.meraki.domains.organizations.networks.group_policies.scheduling.monday.to, null)
            scheduling_tuesday_active             = try(group_policy.scheduling.tuesday.active, local.defaults.meraki.domains.organizations.networks.group_policies.scheduling.tuesday.active, null)
            scheduling_tuesday_from               = try(group_policy.scheduling.tuesday.from, local.defaults.meraki.domains.organizations.networks.group_policies.scheduling.tuesday.from, null)
            scheduling_tuesday_to                 = try(group_policy.scheduling.tuesday.to, local.defaults.meraki.domains.organizations.networks.group_policies.scheduling.tuesday.to, null)
            scheduling_wednesday_active           = try(group_policy.scheduling.wednesday.active, local.defaults.meraki.domains.organizations.networks.group_policies.scheduling.wednesday.active, null)
            scheduling_wednesday_from             = try(group_policy.scheduling.wednesday.from, local.defaults.meraki.domains.organizations.networks.group_policies.scheduling.wednesday.from, null)
            scheduling_wednesday_to               = try(group_policy.scheduling.wednesday.to, local.defaults.meraki.domains.organizations.networks.group_policies.scheduling.wednesday.to, null)
            scheduling_thursday_active            = try(group_policy.scheduling.thursday.active, local.defaults.meraki.domains.organizations.networks.group_policies.scheduling.thursday.active, null)
            scheduling_thursday_from              = try(group_policy.scheduling.thursday.from, local.defaults.meraki.domains.organizations.networks.group_policies.scheduling.thursday.from, null)
            scheduling_thursday_to                = try(group_policy.scheduling.thursday.to, local.defaults.meraki.domains.organizations.networks.group_policies.scheduling.thursday.to, null)
            scheduling_friday_active              = try(group_policy.scheduling.friday.active, local.defaults.meraki.domains.organizations.networks.group_policies.scheduling.friday.active, null)
            scheduling_friday_from                = try(group_policy.scheduling.friday.from, local.defaults.meraki.domains.organizations.networks.group_policies.scheduling.friday.from, null)
            scheduling_friday_to                  = try(group_policy.scheduling.friday.to, local.defaults.meraki.domains.organizations.networks.group_policies.scheduling.friday.to, null)
            scheduling_saturday_active            = try(group_policy.scheduling.saturday.active, local.defaults.meraki.domains.organizations.networks.group_policies.scheduling.saturday.active, null)
            scheduling_saturday_from              = try(group_policy.scheduling.saturday.from, local.defaults.meraki.domains.organizations.networks.group_policies.scheduling.saturday.from, null)
            scheduling_saturday_to                = try(group_policy.scheduling.saturday.to, local.defaults.meraki.domains.organizations.networks.group_policies.scheduling.saturday.to, null)
            scheduling_sunday_active              = try(group_policy.scheduling.sunday.active, local.defaults.meraki.domains.organizations.networks.group_policies.scheduling.sunday.active, null)
            scheduling_sunday_from                = try(group_policy.scheduling.sunday.from, local.defaults.meraki.domains.organizations.networks.group_policies.scheduling.sunday.from, null)
            scheduling_sunday_to                  = try(group_policy.scheduling.sunday.to, local.defaults.meraki.domains.organizations.networks.group_policies.scheduling.sunday.to, null)
            bandwidth_settings                    = try(group_policy.bandwidth.settings, local.defaults.meraki.domains.organizations.networks.group_policies.bandwidth.settings, null)
            bandwidth_limit_up                    = try(group_policy.bandwidth.bandwidth_limits.limit_up, local.defaults.meraki.domains.organizations.networks.group_policies.bandwidth.bandwidth_limits.limit_up, null)
            bandwidth_limit_down                  = try(group_policy.bandwidth.bandwidth_limits.limit_down, local.defaults.meraki.domains.organizations.networks.group_policies.bandwidth.bandwidth_limits.limit_down, null)
            firewall_and_traffic_shaping_settings = try(group_policy.firewall_and_traffic_shaping.settings, local.defaults.meraki.domains.organizations.networks.group_policies.firewall_and_traffic_shaping.settings, null)
            traffic_shaping_rules = try(group_policy.firewall_and_traffic_shaping.traffic_shaping_rules, null) == null ? null : [
              for firewall_and_traffic_shaping_traffic_shaping_rule in try(group_policy.firewall_and_traffic_shaping.traffic_shaping_rules, []) : {
                definitions = [
                  for definition in try(firewall_and_traffic_shaping_traffic_shaping_rule.definitions, []) : {
                    type  = try(definition.type, local.defaults.meraki.domains.organizations.networks.group_policies.firewall_and_traffic_shaping.traffic_shaping_rules.definitions.type, null)
                    value = try(definition.value, local.defaults.meraki.domains.organizations.networks.group_policies.firewall_and_traffic_shaping.traffic_shaping_rules.definitions.value, null)
                  }
                ]
                per_client_bandwidth_limits_settings                    = try(firewall_and_traffic_shaping_traffic_shaping_rule.per_client_bandwidth_limits.settings, local.defaults.meraki.domains.organizations.networks.group_policies.firewall_and_traffic_shaping.traffic_shaping_rules.per_client_bandwidth_limits.settings, null)
                per_client_bandwidth_limits_bandwidth_limits_limit_up   = try(firewall_and_traffic_shaping_traffic_shaping_rule.per_client_bandwidth_limits.bandwidth_limits.limit_up, local.defaults.meraki.domains.organizations.networks.group_policies.firewall_and_traffic_shaping.traffic_shaping_rules.per_client_bandwidth_limits.bandwidth_limits.limit_up, null)
                per_client_bandwidth_limits_bandwidth_limits_limit_down = try(firewall_and_traffic_shaping_traffic_shaping_rule.per_client_bandwidth_limits.bandwidth_limits.limit_down, local.defaults.meraki.domains.organizations.networks.group_policies.firewall_and_traffic_shaping.traffic_shaping_rules.per_client_bandwidth_limits.bandwidth_limits.limit_down, null)
                dscp_tag_value                                          = try(firewall_and_traffic_shaping_traffic_shaping_rule.dscp_tag_value, local.defaults.meraki.domains.organizations.networks.group_policies.firewall_and_traffic_shaping.traffic_shaping_rules.dscp_tag_value, null)
                pcp_tag_value                                           = try(firewall_and_traffic_shaping_traffic_shaping_rule.pcp_tag_value, local.defaults.meraki.domains.organizations.networks.group_policies.firewall_and_traffic_shaping.traffic_shaping_rules.pcp_tag_value, null)
                priority                                                = try(firewall_and_traffic_shaping_traffic_shaping_rule.priority, local.defaults.meraki.domains.organizations.networks.group_policies.firewall_and_traffic_shaping.traffic_shaping_rules.priority, null)
              }
            ]
            l3_firewall_rules = try(group_policy.firewall_and_traffic_shaping.l3_firewall_rules, null) == null ? null : [
              for firewall_and_traffic_shaping_l3_firewall_rule in try(group_policy.firewall_and_traffic_shaping.l3_firewall_rules, []) : {
                comment   = try(firewall_and_traffic_shaping_l3_firewall_rule.comment, local.defaults.meraki.domains.organizations.networks.group_policies.firewall_and_traffic_shaping.l3_firewall_rules.comment, null)
                policy    = try(firewall_and_traffic_shaping_l3_firewall_rule.policy, local.defaults.meraki.domains.organizations.networks.group_policies.firewall_and_traffic_shaping.l3_firewall_rules.policy, null)
                protocol  = try(firewall_and_traffic_shaping_l3_firewall_rule.protocol, local.defaults.meraki.domains.organizations.networks.group_policies.firewall_and_traffic_shaping.l3_firewall_rules.protocol, null)
                dest_port = try(firewall_and_traffic_shaping_l3_firewall_rule.destination_port, local.defaults.meraki.domains.organizations.networks.group_policies.firewall_and_traffic_shaping.l3_firewall_rules.destination_port, null)
                dest_cidr = try(firewall_and_traffic_shaping_l3_firewall_rule.destination_cidr, local.defaults.meraki.domains.organizations.networks.group_policies.firewall_and_traffic_shaping.l3_firewall_rules.destination_cidr, null)
              }
            ]
            l7_firewall_rules = try(group_policy.firewall_and_traffic_shaping.l7_firewall_rules, null) == null ? null : [
              for firewall_and_traffic_shaping_l7_firewall_rule in try(group_policy.firewall_and_traffic_shaping.l7_firewall_rules, []) : {
                policy = try(firewall_and_traffic_shaping_l7_firewall_rule.policy, local.defaults.meraki.domains.organizations.networks.group_policies.firewall_and_traffic_shaping.l7_firewall_rules.policy, null)
                type   = try(firewall_and_traffic_shaping_l7_firewall_rule.type, local.defaults.meraki.domains.organizations.networks.group_policies.firewall_and_traffic_shaping.l7_firewall_rules.type, null)
                value  = try(firewall_and_traffic_shaping_l7_firewall_rule.value, local.defaults.meraki.domains.organizations.networks.group_policies.firewall_and_traffic_shaping.l7_firewall_rules.value, null)
              }
            ]
            content_filtering_allowed_url_patterns_settings   = try(group_policy.content_filtering.allowed_url_patterns.settings, local.defaults.meraki.domains.organizations.networks.group_policies.content_filtering.allowed_url_patterns.settings, null)
            content_filtering_allowed_url_patterns            = try(group_policy.content_filtering.allowed_url_patterns.patterns, local.defaults.meraki.domains.organizations.networks.group_policies.content_filtering.allowed_url_patterns.patterns, null)
            content_filtering_blocked_url_patterns_settings   = try(group_policy.content_filtering.blocked_url_patterns.settings, local.defaults.meraki.domains.organizations.networks.group_policies.content_filtering.blocked_url_patterns.settings, null)
            content_filtering_blocked_url_patterns            = try(group_policy.content_filtering.blocked_url_patterns.patterns, local.defaults.meraki.domains.organizations.networks.group_policies.content_filtering.blocked_url_patterns.patterns, null)
            content_filtering_blocked_url_categories_settings = try(group_policy.content_filtering.blocked_url_categories.settings, local.defaults.meraki.domains.organizations.networks.group_policies.content_filtering.blocked_url_categories.settings, null)
            content_filtering_blocked_url_categories          = try(group_policy.content_filtering.blocked_url_categories.categories, local.defaults.meraki.domains.organizations.networks.group_policies.content_filtering.blocked_url_categories.categories, null)
            splash_auth_settings                              = try(group_policy.splash_auth_settings, local.defaults.meraki.domains.organizations.networks.group_policies.splash_auth_settings, null)
            vlan_tagging_settings                             = try(group_policy.vlan_tagging.settings, local.defaults.meraki.domains.organizations.networks.group_policies.vlan_tagging.settings, null)
            vlan_tagging_vlan_id                              = try(group_policy.vlan_tagging.vlan_id, local.defaults.meraki.domains.organizations.networks.group_policies.vlan_tagging.vlan_id, null)
            bonjour_forwarding_settings                       = try(group_policy.bonjour_forwarding.settings, local.defaults.meraki.domains.organizations.networks.group_policies.bonjour_forwarding.settings, null)
            bonjour_forwarding_rules = try(group_policy.bonjour_forwarding.rules, null) == null ? null : [
              for bonjour_forwarding_rule in try(group_policy.bonjour_forwarding.rules, []) : {
                description = try(bonjour_forwarding_rule.description, local.defaults.meraki.domains.organizations.networks.group_policies.bonjour_forwarding.rules.description, null)
                vlan_id     = try(bonjour_forwarding_rule.vlan_id, local.defaults.meraki.domains.organizations.networks.group_policies.bonjour_forwarding.rules.vlan_id, null)
                services    = try(bonjour_forwarding_rule.services, local.defaults.meraki.domains.organizations.networks.group_policies.bonjour_forwarding.rules.services, null)
              }
            ]
          }
        ]
      ]
    ]
  ])
}

resource "meraki_network_group_policy" "networks_group_policies" {
  for_each                                          = { for v in local.networks_group_policies : v.key => v }
  network_id                                        = each.value.network_id
  name                                              = each.value.name
  scheduling_enabled                                = each.value.scheduling_enabled
  scheduling_monday_active                          = each.value.scheduling_monday_active
  scheduling_monday_from                            = each.value.scheduling_monday_from
  scheduling_monday_to                              = each.value.scheduling_monday_to
  scheduling_tuesday_active                         = each.value.scheduling_tuesday_active
  scheduling_tuesday_from                           = each.value.scheduling_tuesday_from
  scheduling_tuesday_to                             = each.value.scheduling_tuesday_to
  scheduling_wednesday_active                       = each.value.scheduling_wednesday_active
  scheduling_wednesday_from                         = each.value.scheduling_wednesday_from
  scheduling_wednesday_to                           = each.value.scheduling_wednesday_to
  scheduling_thursday_active                        = each.value.scheduling_thursday_active
  scheduling_thursday_from                          = each.value.scheduling_thursday_from
  scheduling_thursday_to                            = each.value.scheduling_thursday_to
  scheduling_friday_active                          = each.value.scheduling_friday_active
  scheduling_friday_from                            = each.value.scheduling_friday_from
  scheduling_friday_to                              = each.value.scheduling_friday_to
  scheduling_saturday_active                        = each.value.scheduling_saturday_active
  scheduling_saturday_from                          = each.value.scheduling_saturday_from
  scheduling_saturday_to                            = each.value.scheduling_saturday_to
  scheduling_sunday_active                          = each.value.scheduling_sunday_active
  scheduling_sunday_from                            = each.value.scheduling_sunday_from
  scheduling_sunday_to                              = each.value.scheduling_sunday_to
  bandwidth_settings                                = each.value.bandwidth_settings
  bandwidth_limit_up                                = each.value.bandwidth_limit_up
  bandwidth_limit_down                              = each.value.bandwidth_limit_down
  firewall_and_traffic_shaping_settings             = each.value.firewall_and_traffic_shaping_settings
  traffic_shaping_rules                             = each.value.traffic_shaping_rules
  l3_firewall_rules                                 = each.value.l3_firewall_rules
  l7_firewall_rules                                 = each.value.l7_firewall_rules
  content_filtering_allowed_url_patterns_settings   = each.value.content_filtering_allowed_url_patterns_settings
  content_filtering_allowed_url_patterns            = each.value.content_filtering_allowed_url_patterns
  content_filtering_blocked_url_patterns_settings   = each.value.content_filtering_blocked_url_patterns_settings
  content_filtering_blocked_url_patterns            = each.value.content_filtering_blocked_url_patterns
  content_filtering_blocked_url_categories_settings = each.value.content_filtering_blocked_url_categories_settings
  content_filtering_blocked_url_categories          = each.value.content_filtering_blocked_url_categories
  splash_auth_settings                              = each.value.splash_auth_settings
  vlan_tagging_settings                             = each.value.vlan_tagging_settings
  vlan_tagging_vlan_id                              = each.value.vlan_tagging_vlan_id
  bonjour_forwarding_settings                       = each.value.bonjour_forwarding_settings
  bonjour_forwarding_rules                          = each.value.bonjour_forwarding_rules
}

locals {
  networks_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                                       = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id                                = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          local_status_page_enabled                 = try(network.settings.local_status_page_enabled, local.defaults.meraki.domains.organizations.networks.settings.local_status_page_enabled, null)
          remote_status_page_enabled                = try(network.settings.remote_status_page, local.defaults.meraki.domains.organizations.networks.settings.remote_status_page, null)
          local_status_page_authentication_enabled  = try(network.settings.local_status_page_authentication.enabled, local.defaults.meraki.domains.organizations.networks.settings.local_status_page_authentication.enabled, null)
          local_status_page_authentication_username = try(network.settings.local_status_page_authentication.username, local.defaults.meraki.domains.organizations.networks.settings.local_status_page_authentication.username, null)
          local_status_page_authentication_password = try(network.settings.local_status_page_authentication.password, local.defaults.meraki.domains.organizations.networks.settings.local_status_page_authentication.password, null)
          secure_port_enabled                       = try(network.settings.secure_port, local.defaults.meraki.domains.organizations.networks.settings.secure_port, null)
          named_vlans_enabled                       = try(network.settings.named_vlans, local.defaults.meraki.domains.organizations.networks.settings.named_vlans, null)
        } if try(network.settings, null) != null
      ]
    ]
  ])
}

resource "meraki_network_settings" "networks_settings" {
  for_each                                  = { for v in local.networks_settings : v.key => v }
  network_id                                = each.value.network_id
  local_status_page_enabled                 = each.value.local_status_page_enabled
  remote_status_page_enabled                = each.value.remote_status_page_enabled
  local_status_page_authentication_enabled  = each.value.local_status_page_authentication_enabled
  local_status_page_authentication_username = each.value.local_status_page_authentication_username
  local_status_page_authentication_password = each.value.local_status_page_authentication_password
  secure_port_enabled                       = each.value.secure_port_enabled
  named_vlans_enabled                       = each.value.named_vlans_enabled
}

locals {
  networks_snmp = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key              = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id       = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          access           = try(network.snmp.access, local.defaults.meraki.domains.organizations.networks.snmp.access, null)
          community_string = try(network.snmp.community_string, local.defaults.meraki.domains.organizations.networks.snmp.community_string, null)
          users = try(network.snmp.users, null) == null ? null : [
            for user in try(network.snmp.users, []) : {
              username   = try(user.username, local.defaults.meraki.domains.organizations.networks.snmp.users.username, null)
              passphrase = try(user.passphrase, local.defaults.meraki.domains.organizations.networks.snmp.users.passphrase, null)
            }
          ]
        } if try(network.snmp, null) != null
      ]
    ]
  ])
}

resource "meraki_network_snmp" "networks_snmp" {
  for_each         = { for v in local.networks_snmp : v.key => v }
  network_id       = each.value.network_id
  access           = each.value.access
  community_string = each.value.community_string
  users            = each.value.users
}

locals {
  networks_syslog_servers = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          servers = [
            for syslog_server in try(network.syslog_servers, []) : {
              host  = try(syslog_server.host, local.defaults.meraki.domains.organizations.networks.syslog_servers.host, null)
              port  = try(syslog_server.port, local.defaults.meraki.domains.organizations.networks.syslog_servers.port, null)
              roles = try(syslog_server.roles, local.defaults.meraki.domains.organizations.networks.syslog_servers.roles, null)
            }
          ]
        } if try(network.syslog_servers, null) != null
      ]
    ]
  ])
}

resource "meraki_network_syslog_servers" "networks_syslog_servers" {
  for_each   = { for v in local.networks_syslog_servers : v.key => v }
  network_id = each.value.network_id
  servers    = each.value.servers
}

locals {
  networks_vlan_profiles = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for vlan_profile in try(network.vlan_profiles, []) : {
            key        = format("%s/%s/%s/%s", domain.name, organization.name, network.name, vlan_profile.name)
            network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
            name       = try(vlan_profile.name, local.defaults.meraki.domains.organizations.networks.vlan_profiles.name, null)
            vlan_names = [
              for vlan_name in try(vlan_profile.vlan_names, []) : {
                name                     = try(vlan_name.name, local.defaults.meraki.domains.organizations.networks.vlan_profiles.vlan_names.name, null)
                vlan_id                  = try(vlan_name.vlan_id, local.defaults.meraki.domains.organizations.networks.vlan_profiles.vlan_names.vlan_id, null)
                adaptive_policy_group_id = try(vlan_name.adaptive_policy_group, local.defaults.meraki.domains.organizations.networks.vlan_profiles.vlan_names.adaptive_policy_group, null)
              }
            ]
            vlan_groups = [
              for vlan_group in try(vlan_profile.vlan_groups, []) : {
                name     = try(vlan_group.name, local.defaults.meraki.domains.organizations.networks.vlan_profiles.vlan_groups.name, null)
                vlan_ids = try(vlan_group.vlan_ids, local.defaults.meraki.domains.organizations.networks.vlan_profiles.vlan_groups.vlan_ids, null)
              }
            ]
            iname = try(vlan_profile.iname, local.defaults.meraki.domains.organizations.networks.vlan_profiles.iname, null)
          }
        ]
      ]
    ]
  ])
}

resource "meraki_network_vlan_profile" "networks_vlan_profiles" {
  for_each    = { for v in local.networks_vlan_profiles : v.key => v }
  network_id  = each.value.network_id
  name        = each.value.name
  vlan_names  = each.value.vlan_names
  vlan_groups = each.value.vlan_groups
  iname       = each.value.iname
}

locals {
  networks_devices_claim = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          serials    = [for d in network.devices : d.serial]
        } if try(network.devices, null) != null
      ]
    ]
  ])
}

resource "meraki_network_device_claim" "networks_devices_claim" {
  for_each   = { for v in local.networks_devices_claim : v.key => v }
  network_id = each.value.network_id
  serials    = each.value.serials
}

locals {
  networks_floor_plans = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : [
          for floor_plan in try(network.floor_plans, []) : {
            key                     = format("%s/%s/%s/%s", domain.name, organization.name, network.name, floor_plan.name)
            network_id              = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
            name                    = try(floor_plan.name, local.defaults.meraki.domains.organizations.networks.floor_plans.name, null)
            center_lat              = try(floor_plan.center.lat, local.defaults.meraki.domains.organizations.networks.floor_plans.center.lat, null)
            center_lng              = try(floor_plan.center.lng, local.defaults.meraki.domains.organizations.networks.floor_plans.center.lng, null)
            bottom_left_corner_lat  = try(floor_plan.bottom_left_corner.lat, local.defaults.meraki.domains.organizations.networks.floor_plans.bottom_left_corner.lat, null)
            bottom_left_corner_lng  = try(floor_plan.bottom_left_corner.lng, local.defaults.meraki.domains.organizations.networks.floor_plans.bottom_left_corner.lng, null)
            bottom_right_corner_lat = try(floor_plan.bottom_right_corner.lat, local.defaults.meraki.domains.organizations.networks.floor_plans.bottom_right_corner.lat, null)
            bottom_right_corner_lng = try(floor_plan.bottom_right_corner.lng, local.defaults.meraki.domains.organizations.networks.floor_plans.bottom_right_corner.lng, null)
            top_left_corner_lat     = try(floor_plan.top_left_corner.lat, local.defaults.meraki.domains.organizations.networks.floor_plans.top_left_corner.lat, null)
            top_left_corner_lng     = try(floor_plan.top_left_corner.lng, local.defaults.meraki.domains.organizations.networks.floor_plans.top_left_corner.lng, null)
            top_right_corner_lat    = try(floor_plan.top_right_corner.lat, local.defaults.meraki.domains.organizations.networks.floor_plans.top_right_corner.lat, null)
            top_right_corner_lng    = try(floor_plan.top_right_corner.lng, local.defaults.meraki.domains.organizations.networks.floor_plans.top_right_corner.lng, null)
            floor_number            = try(floor_plan.floor_number, local.defaults.meraki.domains.organizations.networks.floor_plans.floor_number, null)
            image_contents          = try(floor_plan.image_contents, local.defaults.meraki.domains.organizations.networks.floor_plans.image_contents, null)
          }
        ]
      ]
    ]
  ])
}

resource "meraki_network_floor_plan" "networks_floor_plans" {
  for_each                = { for v in local.networks_floor_plans : v.key => v }
  network_id              = each.value.network_id
  name                    = each.value.name
  center_lat              = each.value.center_lat
  center_lng              = each.value.center_lng
  bottom_left_corner_lat  = each.value.bottom_left_corner_lat
  bottom_left_corner_lng  = each.value.bottom_left_corner_lng
  bottom_right_corner_lat = each.value.bottom_right_corner_lat
  bottom_right_corner_lng = each.value.bottom_right_corner_lng
  top_left_corner_lat     = each.value.top_left_corner_lat
  top_left_corner_lng     = each.value.top_left_corner_lng
  top_right_corner_lat    = each.value.top_right_corner_lat
  top_right_corner_lng    = each.value.top_right_corner_lng
  floor_number            = each.value.floor_number
  image_contents          = each.value.image_contents
}

locals {
  networks_cellular_gateway_dhcp = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                    = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id             = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          dhcp_lease_time        = try(network.cellular_gateway.dhcp.dhcp_lease_time, local.defaults.meraki.domains.organizations.networks.cellular_gateway.dhcp.dhcp_lease_time, null)
          dns_nameservers        = try(network.cellular_gateway.dhcp.dns_nameservers, local.defaults.meraki.domains.organizations.networks.cellular_gateway.dhcp.dns_nameservers, null)
          dns_custom_nameservers = try(network.cellular_gateway.dhcp.dns_custom_nameservers, local.defaults.meraki.domains.organizations.networks.cellular_gateway.dhcp.dns_custom_nameservers, null)
        } if try(network.cellular_gateway.dhcp, null) != null
      ]
    ]
  ])
}

resource "meraki_cellular_gateway_dhcp" "networks_cellular_gateway_dhcp" {
  for_each               = { for v in local.networks_cellular_gateway_dhcp : v.key => v }
  network_id             = each.value.network_id
  dhcp_lease_time        = each.value.dhcp_lease_time
  dns_nameservers        = each.value.dns_nameservers
  dns_custom_nameservers = each.value.dns_custom_nameservers
}

locals {
  networks_cellular_gateway_subnet_pool = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          mask       = try(network.cellular_gateway.subnet_pool.mask, local.defaults.meraki.domains.organizations.networks.cellular_gateway.subnet_pool.mask, null)
          cidr       = try(network.cellular_gateway.subnet_pool.cidr, local.defaults.meraki.domains.organizations.networks.cellular_gateway.subnet_pool.cidr, null)
        } if try(network.cellular_gateway.subnet_pool, null) != null
      ]
    ]
  ])
}

resource "meraki_cellular_gateway_subnet_pool" "networks_cellular_gateway_subnet_pool" {
  for_each   = { for v in local.networks_cellular_gateway_subnet_pool : v.key => v }
  network_id = each.value.network_id
  mask       = each.value.mask
  cidr       = each.value.cidr
}

locals {
  networks_cellular_gateway_uplink_bandwidth_limits = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key                         = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id                  = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          bandwidth_limits_limit_up   = try(network.cellular_gateway.uplink_bandwidth_limits.limit_up, local.defaults.meraki.domains.organizations.networks.cellular_gateway.uplink_bandwidth_limits.limit_up, null)
          bandwidth_limits_limit_down = try(network.cellular_gateway.uplink_bandwidth_limits.limit_down, local.defaults.meraki.domains.organizations.networks.cellular_gateway.uplink_bandwidth_limits.limit_down, null)
        } if try(network.cellular_gateway.uplink_bandwidth_limits, null) != null
      ]
    ]
  ])
}

resource "meraki_cellular_gateway_uplink" "networks_cellular_gateway_uplink_bandwidth_limits" {
  for_each                    = { for v in local.networks_cellular_gateway_uplink_bandwidth_limits : v.key => v }
  network_id                  = each.value.network_id
  bandwidth_limits_limit_up   = each.value.bandwidth_limits_limit_up
  bandwidth_limits_limit_down = each.value.bandwidth_limits_limit_down
}

locals {
  networks_cellular_gateway_connectivity_monitoring_destinations = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key        = format("%s/%s/%s", domain.name, organization.name, network.name)
          network_id = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
          destinations = [
            for cellular_gateway_connectivity_monitoring_destination in try(network.cellular_gateway.connectivity_monitoring_destinations, []) : {
              ip          = try(cellular_gateway_connectivity_monitoring_destination.ip, local.defaults.meraki.domains.organizations.networks.cellular_gateway.connectivity_monitoring_destinations.ip, null)
              description = try(cellular_gateway_connectivity_monitoring_destination.description, local.defaults.meraki.domains.organizations.networks.cellular_gateway.connectivity_monitoring_destinations.description, null)
              default     = try(cellular_gateway_connectivity_monitoring_destination.default, local.defaults.meraki.domains.organizations.networks.cellular_gateway.connectivity_monitoring_destinations.default, null)
            }
          ]
        } if try(network.cellular_gateway.connectivity_monitoring_destinations, null) != null
      ]
    ]
  ])
}

resource "meraki_cellular_gateway_connectivity_monitoring_destinations" "networks_cellular_gateway_connectivity_monitoring_destinations" {
  for_each     = { for v in local.networks_cellular_gateway_connectivity_monitoring_destinations : v.key => v }
  network_id   = each.value.network_id
  destinations = each.value.destinations
}
