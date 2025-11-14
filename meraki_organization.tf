locals {
  organizations = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : {
        key     = format("%s/%s", domain.name, organization.name)
        name    = try(organization.name, local.defaults.meraki.domains.organizations.name, null)
        managed = try(organization.managed, local.defaults.meraki.domains.organizations.managed, true)
        management_details = try(organization.management, null) == null ? null : [
          for management in try(organization.management, []) : {
            name  = try(management.name, local.defaults.meraki.domains.organizations.management.name, null)
            value = try(management.value, local.defaults.meraki.domains.organizations.management.value, null)
          }
        ]
      }
    ]
  ])

  managed_organizations = [
    for organization in local.organizations :
    organization if organization.managed
  ]

  unmanaged_organizations = [
    for organization in local.organizations :
    organization if !organization.managed
  ]
}

resource "meraki_organization" "organizations" {
  for_each           = { for organization in local.managed_organizations : organization.key => organization }
  name               = each.value.name
  management_details = each.value.management_details
}

data "meraki_organization" "organizations" {
  for_each = { for organization in local.unmanaged_organizations : organization.key => organization }
  name     = each.value.name
}

locals {
  organization_ids = {
    for organization in local.organizations :
    organization.key =>
    organization.managed ?
    meraki_organization.organizations[organization.key].id :
    data.meraki_organization.organizations[organization.key].id
  }
}

locals {
  organizations_networks = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key             = format("%s/%s/%s", domain.name, organization.name, network.name)
          managed         = try(network.managed, local.defaults.meraki.domains.organizations.networks.managed, true)
          organization_id = local.organization_ids[format("%s/%s", domain.name, organization.name)]
          name            = try(network.name, local.defaults.meraki.domains.organizations.networks.name, null)
          product_types   = try(network.product_types, local.defaults.meraki.domains.organizations.networks.product_types, null)
          tags            = try(network.tags, local.defaults.meraki.domains.organizations.networks.tags, null)
          time_zone       = try(network.time_zone, local.defaults.meraki.domains.organizations.networks.time_zone, null)
          notes           = try(network.notes, local.defaults.meraki.domains.organizations.networks.notes, null)
        }
      ]
    ]
  ])

  managed_networks = [
    for network in local.organizations_networks : network if network.managed
  ]

  unmanaged_networks = [
    for network in local.organizations_networks : network if !network.managed
  ]
}

resource "meraki_network" "organizations_networks" {
  for_each        = { for v in local.managed_networks : v.key => v }
  name            = each.value.name
  notes           = each.value.notes
  organization_id = each.value.organization_id
  product_types   = each.value.product_types
  tags            = each.value.tags
  time_zone       = each.value.time_zone
  depends_on = [
    meraki_organization_inventory_claim.organizations_inventory,
  ]
}

data "meraki_network" "organizations_networks" {
  for_each        = { for v in local.unmanaged_networks : v.key => v }
  name            = each.value.name
  organization_id = each.value.organization_id
}

locals {
  network_ids = {
    for network in local.organizations_networks :
    network.key =>
    network.managed ?
    meraki_network.organizations_networks[network.key].id :
    data.meraki_network.organizations_networks[network.key].id
  }
}

locals {
  organizations_login_security = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : {
        key                                                 = format("%s/%s", domain.name, organization.name)
        organization_id                                     = local.organization_ids[format("%s/%s", domain.name, organization.name)]
        enforce_password_expiration                         = try(organization.login_security.enforce_password_expiration, local.defaults.meraki.domains.organizations.login_security.enforce_password_expiration, null)
        password_expiration_days                            = try(organization.login_security.password_expiration_days, local.defaults.meraki.domains.organizations.login_security.password_expiration_days, null)
        enforce_different_passwords                         = try(organization.login_security.enforce_different_passwords, local.defaults.meraki.domains.organizations.login_security.enforce_different_passwords, null)
        num_different_passwords                             = try(organization.login_security.num_different_passwords, local.defaults.meraki.domains.organizations.login_security.num_different_passwords, null)
        enforce_strong_passwords                            = try(organization.login_security.enforce_strong_passwords, local.defaults.meraki.domains.organizations.login_security.enforce_strong_passwords, null)
        enforce_account_lockout                             = try(organization.login_security.enforce_account_lockout, local.defaults.meraki.domains.organizations.login_security.enforce_account_lockout, null)
        account_lockout_attempts                            = try(organization.login_security.account_lockout_attempts, local.defaults.meraki.domains.organizations.login_security.account_lockout_attempts, null)
        enforce_idle_timeout                                = try(organization.login_security.enforce_idle_timeout, local.defaults.meraki.domains.organizations.login_security.enforce_idle_timeout, null)
        idle_timeout_minutes                                = try(organization.login_security.idle_timeout_minutes, local.defaults.meraki.domains.organizations.login_security.idle_timeout_minutes, null)
        enforce_two_factor_auth                             = try(organization.login_security.enforce_two_factor_auth, local.defaults.meraki.domains.organizations.login_security.enforce_two_factor_auth, null)
        enforce_login_ip_ranges                             = try(organization.login_security.enforce_login_ip_ranges, local.defaults.meraki.domains.organizations.login_security.enforce_login_ip_ranges, null)
        login_ip_ranges                                     = try(organization.login_security.login_ip_ranges, local.defaults.meraki.domains.organizations.login_security.login_ip_ranges, null)
        api_authentication_ip_restrictions_for_keys_enabled = try(organization.login_security.api_authentication.enabled, local.defaults.meraki.domains.organizations.login_security.api_authentication.enabled, null)
        api_authentication_ip_restrictions_for_keys_ranges  = try(organization.login_security.api_authentication.ranges, local.defaults.meraki.domains.organizations.login_security.api_authentication.ranges, null)
      } if try(organization.login_security, null) != null
    ]
  ])
}

resource "meraki_organization_login_security" "organizations_login_security" {
  for_each                                            = { for v in local.organizations_login_security : v.key => v }
  organization_id                                     = each.value.organization_id
  enforce_password_expiration                         = each.value.enforce_password_expiration
  password_expiration_days                            = each.value.password_expiration_days
  enforce_different_passwords                         = each.value.enforce_different_passwords
  num_different_passwords                             = each.value.num_different_passwords
  enforce_strong_passwords                            = each.value.enforce_strong_passwords
  enforce_account_lockout                             = each.value.enforce_account_lockout
  account_lockout_attempts                            = each.value.account_lockout_attempts
  enforce_idle_timeout                                = each.value.enforce_idle_timeout
  idle_timeout_minutes                                = each.value.idle_timeout_minutes
  enforce_two_factor_auth                             = each.value.enforce_two_factor_auth
  enforce_login_ip_ranges                             = each.value.enforce_login_ip_ranges
  login_ip_ranges                                     = each.value.login_ip_ranges
  api_authentication_ip_restrictions_for_keys_enabled = each.value.api_authentication_ip_restrictions_for_keys_enabled
  api_authentication_ip_restrictions_for_keys_ranges  = each.value.api_authentication_ip_restrictions_for_keys_ranges
}

locals {
  organizations_snmp = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : {
        key             = format("%s/%s", domain.name, organization.name)
        organization_id = local.organization_ids[format("%s/%s", domain.name, organization.name)]
        v2c_enabled     = try(organization.snmp.v2c, local.defaults.meraki.domains.organizations.snmp.v2c, null)
        v3_enabled      = try(organization.snmp.v3, local.defaults.meraki.domains.organizations.snmp.v3, null)
        v3_auth_mode    = try(organization.snmp.v3_auth_mode, local.defaults.meraki.domains.organizations.snmp.v3_auth_mode, null)
        v3_auth_pass    = try(organization.snmp.v3_auth_pass, local.defaults.meraki.domains.organizations.snmp.v3_auth_pass, null)
        v3_priv_mode    = try(organization.snmp.v3_priv_mode, local.defaults.meraki.domains.organizations.snmp.v3_priv_mode, null)
        v3_priv_pass    = try(organization.snmp.v3_priv_pass, local.defaults.meraki.domains.organizations.snmp.v3_priv_pass, null)
        peer_ips        = try(organization.snmp.peer_ips, local.defaults.meraki.domains.organizations.snmp.peer_ips, null)
      } if try(organization.snmp, null) != null
    ]
  ])
}

resource "meraki_organization_snmp" "organizations_snmp" {
  for_each        = { for v in local.organizations_snmp : v.key => v }
  organization_id = each.value.organization_id
  v2c_enabled     = each.value.v2c_enabled
  v3_enabled      = each.value.v3_enabled
  v3_auth_mode    = each.value.v3_auth_mode
  v3_auth_pass    = each.value.v3_auth_pass
  v3_priv_mode    = each.value.v3_priv_mode
  v3_priv_pass    = each.value.v3_priv_pass
  peer_ips        = each.value.peer_ips
}

locals {
  organizations_admins = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for admin in try(organization.admins, []) : {
          key             = format("%s/%s/%s", domain.name, organization.name, try(admin.name, local.defaults.meraki.domains.organizations.admins.name, null))
          organization_id = local.organization_ids[format("%s/%s", domain.name, organization.name)]
          email           = try(admin.email, local.defaults.meraki.domains.organizations.admins.email, null)
          name            = try(admin.name, local.defaults.meraki.domains.organizations.admins.name, null)
          org_access      = try(admin.organization_access, local.defaults.meraki.domains.organizations.admins.organization_access, null)
          tags = try(admin.tags, null) == null ? null : [
            for tag in try(admin.tags, []) : {
              tag    = tag.tag
              access = try(tag.access, local.defaults.meraki.domains.organizations.admins.tags.access, null)
            }
          ]
          networks = try(admin.networks, null) == null ? null : [
            for network in try(admin.networks, []) : {
              id     = local.network_ids[format("%s/%s/%s", domain.name, organization.name, network.name)]
              access = try(network.access, local.defaults.meraki.domains.organizations.admins.networks.access, null)
            }
          ]
          # authentication_method = try(admin.authentication_method, local.defaults.meraki.domains.organizations.admins.authentication_method, null)
        }
      ]
    ]
  ])
}

resource "meraki_organization_admin" "organizations_admins" {
  for_each        = { for v in local.organizations_admins : v.key => v }
  organization_id = each.value.organization_id
  name            = each.value.name
  email           = each.value.email
  # authentication_method = each.value.authentication_method
  org_access = each.value.org_access
  networks   = each.value.networks
  tags       = each.value.tags
}

locals {
  organizations_inventory = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : {
        key             = format("%s/%s", domain.name, organization.name)
        organization_id = local.organization_ids[format("%s/%s", domain.name, organization.name)]
        licenses = try(organization.inventory.licenses, null) == null ? null : [
          for license in try(organization.inventory.licenses, []) : {
            key  = license.key
            mode = license.mode
          }
        ]
        orders  = try(organization.inventory.orders, [])
        serials = try(organization.inventory.serials, [])
      } if try(organization.inventory, null) != null
    ]
  ])
}

resource "meraki_organization_inventory_claim" "organizations_inventory" {
  for_each        = { for v in local.organizations_inventory : v.key => v }
  organization_id = each.value.organization_id
  licenses        = each.value.licenses
  orders          = each.value.orders
  serials         = each.value.serials
}

# Use existing network data in adaptive policy settings
locals {
  organizations_adaptive_policy_settings_enabled_networks = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : {
        key             = format("%s/%s", domain.name, organization.name)
        organization_id = local.organization_ids[format("%s/%s", domain.name, organization.name)]
        enabled_networks = try(organization.adaptive_policy.settings_enabled_networks, null) == null ? null : [
          for network in try(organization.adaptive_policy.settings_enabled_networks, []) :
          local.network_ids[format("%s/%s/%s", domain.name, organization.name, network)]
        ]
      } if try(organization.adaptive_policy.settings_enabled_networks, null) != null
    ]
  ])
}

resource "meraki_organization_adaptive_policy_settings" "organizations_adaptive_policy_settings_enabled_networks" {
  for_each         = { for v in local.organizations_adaptive_policy_settings_enabled_networks : v.key => v }
  organization_id  = each.value.organization_id
  enabled_networks = each.value.enabled_networks
  depends_on = [
    meraki_network_device_claim.networks_devices_claim,
  ]
}

locals {
  organizations_adaptive_policy_groups = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for adaptive_policy_group in try(organization.adaptive_policy.groups, []) : {
          key             = format("%s/%s/%s", domain.name, organization.name, adaptive_policy_group.name)
          organization_id = local.organization_ids[format("%s/%s", domain.name, organization.name)]
          group_name      = try(adaptive_policy_group.name, local.defaults.meraki.domains.organizations.adaptive_policy.groups.name, null)
          sgt             = try(adaptive_policy_group.sgt, local.defaults.meraki.domains.organizations.adaptive_policy.groups.sgt, null)
          description     = try(adaptive_policy_group.description, local.defaults.meraki.domains.organizations.adaptive_policy.groups.description, null)
        }
      ]
    ]
  ])
}

resource "meraki_organization_adaptive_policy_group" "organizations_adaptive_policy_groups" {
  for_each        = { for v in local.organizations_adaptive_policy_groups : v.key => v }
  organization_id = each.value.organization_id
  name            = each.value.group_name
  sgt             = each.value.sgt
  description     = each.value.description
}

locals {
  organizations_adaptive_policy_acls = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for adaptive_policy_acl in try(organization.adaptive_policy.acls, []) : {
          key             = format("%s/%s/%s", domain.name, organization.name, adaptive_policy_acl.name)
          organization_id = local.organization_ids[format("%s/%s", domain.name, organization.name)]
          name            = try(adaptive_policy_acl.name, local.defaults.meraki.domains.organizations.adaptive_policy.acls.name, null)
          description     = try(adaptive_policy_acl.description, local.defaults.meraki.domains.organizations.adaptive_policy.acls.description, null)
          rules = [
            for rule in try(adaptive_policy_acl.rules, []) : {
              policy          = try(rule.policy, local.defaults.meraki.domains.organizations.adaptive_policy.acls.rules.policy, null)
              protocol        = try(rule.protocol, local.defaults.meraki.domains.organizations.adaptive_policy.acls.rules.protocol, null)
              src_port        = try(rule.source_port, local.defaults.meraki.domains.organizations.adaptive_policy.acls.rules.source_port, null)
              dst_port        = try(rule.destination_port, local.defaults.meraki.domains.organizations.adaptive_policy.acls.rules.destination_port, null)
              log             = try(rule.log, local.defaults.meraki.domains.organizations.adaptive_policy.acls.rules.log, null)
              tcp_established = try(rule.tcp_established, local.defaults.meraki.domains.organizations.adaptive_policy.acls.rules.tcp_established, null)
            }
          ]
          ip_version = try(adaptive_policy_acl.ip_version, local.defaults.meraki.domains.organizations.adaptive_policy.acls.ip_version, null)
        }
      ]
    ]
  ])
}

resource "meraki_organization_adaptive_policy_acl" "organizations_adaptive_policy_acls" {
  for_each        = { for v in local.organizations_adaptive_policy_acls : v.key => v }
  organization_id = each.value.organization_id
  name            = each.value.name
  description     = each.value.description
  rules           = each.value.rules
  ip_version      = each.value.ip_version
  depends_on = [
    meraki_organization_adaptive_policy_group.organizations_adaptive_policy_groups,
  ]
}

locals {
  organizations_adaptive_policy_policies = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for adaptive_policy_policy in try(organization.adaptive_policy.policies, []) : {
          key                    = format("%s/%s/%s", domain.name, organization.name, adaptive_policy_policy.name)
          organization_id        = local.organization_ids[format("%s/%s", domain.name, organization.name)]
          policy_name            = try(adaptive_policy_policy.name, local.defaults.meraki.domains.organizations.adaptive_policy.policies.name, null)
          source_group_name      = try(adaptive_policy_policy.source_group.name, local.defaults.meraki.domains.organizations.adaptive_policy.policies.source_group.name, null)
          source_group_sgt       = try(adaptive_policy_policy.source_group.sgt, local.defaults.meraki.domains.organizations.adaptive_policy.policies.source_group.sgt, null)
          source_group_id        = meraki_organization_adaptive_policy_group.organizations_adaptive_policy_groups[format("%s/%s/%s", domain.name, organization.name, adaptive_policy_policy.source_group.name)].id
          destination_group_name = try(adaptive_policy_policy.destination_group.name, local.defaults.meraki.domains.organizations.adaptive_policy.policies.destination_group.name, null)
          destination_group_sgt  = try(adaptive_policy_policy.destination_group.sgt, local.defaults.meraki.domains.organizations.adaptive_policy.policies.destination_group.sgt, null)
          destination_group_id   = meraki_organization_adaptive_policy_group.organizations_adaptive_policy_groups[format("%s/%s/%s", domain.name, organization.name, adaptive_policy_policy.destination_group.name)].id
          last_entry_rule        = try(adaptive_policy_policy.last_entry_rule, local.defaults.meraki.domains.organizations.adaptive_policy.policies.last_entry_rule, null)
          acls = try(adaptive_policy_policy.acls, null) == null ? null : [
            for acl in try(adaptive_policy_policy.acls, []) : {
              id   = meraki_organization_adaptive_policy_acl.organizations_adaptive_policy_acls[format("%s/%s/%s", domain.name, organization.name, acl)].id
              name = acl
            }
          ]
        }
      ]
    ]
  ])
}

resource "meraki_organization_adaptive_policy" "organizations_adaptive_policy_policies" {
  for_each               = { for v in local.organizations_adaptive_policy_policies : v.key => v }
  organization_id        = each.value.organization_id
  source_group_id        = each.value.source_group_id
  source_group_name      = each.value.source_group_name
  source_group_sgt       = each.value.source_group_sgt
  destination_group_id   = each.value.destination_group_id
  destination_group_name = each.value.destination_group_name
  destination_group_sgt  = each.value.destination_group_sgt
  acls                   = each.value.acls
  last_entry_rule        = each.value.last_entry_rule
}

locals {
  organizations_policy_objects = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for policy_object in try(organization.policy_objects, []) : {
          key             = format("%s/%s/%s", domain.name, organization.name, policy_object.name)
          organization_id = local.organization_ids[format("%s/%s", domain.name, organization.name)]
          name            = try(policy_object.name, local.defaults.meraki.domains.organizations.policy_objects.name, null)
          category        = try(policy_object.category, local.defaults.meraki.domains.organizations.policy_objects.category, null)
          type            = try(policy_object.type, local.defaults.meraki.domains.organizations.policy_objects.type, null)
          cidr            = try(policy_object.cidr, local.defaults.meraki.domains.organizations.policy_objects.cidr, null)
          fqdn            = try(policy_object.fqdn, local.defaults.meraki.domains.organizations.policy_objects.fqdn, null)
          mask            = try(policy_object.mask, local.defaults.meraki.domains.organizations.policy_objects.mask, null)
          ip              = try(policy_object.ip, local.defaults.meraki.domains.organizations.policy_objects.ip, null)
        }
      ]
    ]
  ])
}

resource "meraki_organization_policy_object" "organizations_policy_objects" {
  for_each        = { for v in local.organizations_policy_objects : v.key => v }
  organization_id = each.value.organization_id
  category        = each.value.category
  name            = each.value.name
  type            = each.value.type
  cidr            = each.value.cidr
  fqdn            = each.value.fqdn
  mask            = each.value.mask
  ip              = each.value.ip
}

locals {
  organizations_policy_objects_groups = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for policy_objects_group in try(organization.policy_objects_groups, []) : {
          key             = format("%s/%s/%s", domain.name, organization.name, policy_objects_group.name)
          organization_id = local.organization_ids[format("%s/%s", domain.name, organization.name)]
          name            = try(policy_objects_group.name, local.defaults.meraki.domains.organizations.policy_objects_groups.name, null)
          category        = try(policy_objects_group.category, local.defaults.meraki.domains.organizations.policy_objects_groups.category, null)
          object_ids = try(policy_objects_group.object_names, null) == null ? null : [
            for name in try(policy_objects_group.object_names, []) : meraki_organization_policy_object.organizations_policy_objects[format("%s/%s/%s", domain.name, organization.name, name)].id
          ]
        }
      ]
    ]
  ])
}

resource "meraki_organization_policy_object_group" "organizations_policy_objects_groups" {
  for_each        = { for v in local.organizations_policy_objects_groups : v.key => v }
  organization_id = each.value.organization_id
  name            = each.value.name
  category        = each.value.category
  object_ids      = each.value.object_ids
}

locals {
  organizations_appliance_security_intrusion_allowed_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : {
        key             = format("%s/%s", domain.name, organization.name)
        organization_id = local.organization_ids[format("%s/%s", domain.name, organization.name)]
        allowed_rules = [
          for appliance_security_intrusion_allowed_rule in try(organization.appliance.security_intrusion_allowed_rules, []) : {
            rule_id = try(appliance_security_intrusion_allowed_rule.rule_id, local.defaults.meraki.domains.organizations.appliance.security_intrusion_allowed_rules.rule_id, null)
            message = try(appliance_security_intrusion_allowed_rule.message, local.defaults.meraki.domains.organizations.appliance.security_intrusion_allowed_rules.message, null)
          }
        ]
      } if try(organization.appliance.security_intrusion_allowed_rules, null) != null
    ]
  ])
}

resource "meraki_appliance_organization_security_intrusion" "organizations_appliance_security_intrusion_allowed_rules" {
  for_each        = { for v in local.organizations_appliance_security_intrusion_allowed_rules : v.key => v }
  organization_id = each.value.organization_id
  allowed_rules   = each.value.allowed_rules
}

locals {
  organizations_appliance_third_party_vpn_peers = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : {
        key             = format("%s/%s", domain.name, organization.name)
        organization_id = local.organization_ids[format("%s/%s", domain.name, organization.name)]
        peers = [
          for appliance_third_party_vpn_peer in try(organization.appliance.third_party_vpn_peers, []) : {
            name                                    = try(appliance_third_party_vpn_peer.name, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.name, null)
            public_ip                               = try(appliance_third_party_vpn_peer.public_ip, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.public_ip, null)
            public_hostname                         = try(appliance_third_party_vpn_peer.public_hostname, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.public_hostname, null)
            private_subnets                         = try(appliance_third_party_vpn_peer.private_subnets, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.private_subnets, null)
            local_id                                = try(appliance_third_party_vpn_peer.local_id, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.local_id, null)
            remote_id                               = try(appliance_third_party_vpn_peer.remote_id, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.remote_id, null)
            ipsec_policies_ike_cipher_algo          = try(appliance_third_party_vpn_peer.ipsec_policies.ike_cipher_algo, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.ipsec_policies.ike_cipher_algo, null)
            ipsec_policies_ike_auth_algo            = try(appliance_third_party_vpn_peer.ipsec_policies.ike_auth_algo, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.ipsec_policies.ike_auth_algo, null)
            ipsec_policies_ike_prf_algo             = try(appliance_third_party_vpn_peer.ipsec_policies.ike_prf_algo, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.ipsec_policies.ike_prf_algo, null)
            ipsec_policies_ike_diffie_hellman_group = try(appliance_third_party_vpn_peer.ipsec_policies.ike_diffie_hellman_group, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.ipsec_policies.ike_diffie_hellman_group, null)
            ipsec_policies_ike_lifetime             = try(appliance_third_party_vpn_peer.ipsec_policies.ike_lifetime, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.ipsec_policies.ike_lifetime, null)
            ipsec_policies_child_cipher_algo        = try(appliance_third_party_vpn_peer.ipsec_policies.child_cipher_algo, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.ipsec_policies.child_cipher_algo, null)
            ipsec_policies_child_auth_algo          = try(appliance_third_party_vpn_peer.ipsec_policies.child_auth_algo, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.ipsec_policies.child_auth_algo, null)
            ipsec_policies_child_pfs_group          = try(appliance_third_party_vpn_peer.ipsec_policies.child_pfs_group, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.ipsec_policies.child_pfs_group, null)
            ipsec_policies_child_lifetime           = try(appliance_third_party_vpn_peer.ipsec_policies.child_lifetime, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.ipsec_policies.child_lifetime, null)
            ipsec_policies_preset                   = try(appliance_third_party_vpn_peer.ipsec_policies_preset, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.ipsec_policies_preset, null)
            secret                                  = try(appliance_third_party_vpn_peer.secret, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.secret, null)
            ike_version                             = try(appliance_third_party_vpn_peer.ike_version, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.ike_version, null)
            network_tags                            = try(appliance_third_party_vpn_peer.network_tags, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.network_tags, null)
          }
        ]
      } if try(organization.appliance.third_party_vpn_peers, null) != null
    ]
  ])
}

resource "meraki_appliance_third_party_vpn_peers" "organizations_appliance_third_party_vpn_peers" {
  for_each        = { for v in local.organizations_appliance_third_party_vpn_peers : v.key => v }
  organization_id = each.value.organization_id
  peers           = each.value.peers
  depends_on = [
    meraki_network.organizations_networks,
  ]
}

locals {
  organizations_appliance_vpn_firewall_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : {
        key             = format("%s/%s", domain.name, organization.name)
        organization_id = local.organization_ids[format("%s/%s", domain.name, organization.name)]
        rules = try(organization.appliance.vpn_firewall_rules.rules, null) == null ? null : [
          for rule in try(organization.appliance.vpn_firewall_rules.rules, []) : {
            comment        = try(rule.comment, local.defaults.meraki.domains.organizations.appliance.vpn_firewall_rules.rules.comment, null)
            policy         = try(rule.policy, local.defaults.meraki.domains.organizations.appliance.vpn_firewall_rules.rules.policy, null)
            protocol       = try(rule.protocol, local.defaults.meraki.domains.organizations.appliance.vpn_firewall_rules.rules.protocol, null)
            src_port       = try(rule.source_port, local.defaults.meraki.domains.organizations.appliance.vpn_firewall_rules.rules.source_port, null)
            src_cidr       = try(rule.source_cidr, local.defaults.meraki.domains.organizations.appliance.vpn_firewall_rules.rules.source_cidr, null)
            dest_port      = try(rule.destination_port, local.defaults.meraki.domains.organizations.appliance.vpn_firewall_rules.rules.destination_port, null)
            dest_cidr      = try(rule.destination_cidr, local.defaults.meraki.domains.organizations.appliance.vpn_firewall_rules.rules.destination_cidr, null)
            syslog_enabled = try(rule.syslog, local.defaults.meraki.domains.organizations.appliance.vpn_firewall_rules.rules.syslog, null)
          }
        ]
        syslog_default_rule = try(organization.appliance.vpn_firewall_rules.syslog_default_rule, local.defaults.meraki.domains.organizations.appliance.vpn_firewall_rules.syslog_default_rule, null)
      } if try(organization.appliance.vpn_firewall_rules, null) != null
    ]
  ])
}

resource "meraki_appliance_vpn_firewall_rules" "organizations_appliance_vpn_firewall_rules" {
  for_each            = { for v in local.organizations_appliance_vpn_firewall_rules : v.key => v }
  organization_id     = each.value.organization_id
  rules               = each.value.rules
  syslog_default_rule = each.value.syslog_default_rule
  depends_on = [
    meraki_network.organizations_networks,
  ]
}

locals {
  organizations_early_access_features_opt_ins = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for early_access_features_opt_in in try(organization.early_access_features_opt_ins, []) : {
          key             = format("%s/%s/%s", domain.name, organization.name, early_access_features_opt_in.short_name)
          organization_id = local.organization_ids[format("%s/%s", domain.name, organization.name)]
          short_name      = try(early_access_features_opt_in.short_name, local.defaults.meraki.domains.organizations.early_access_features_opt_ins.short_name, null)
          limit_scope_to_networks = try(early_access_features_opt_in.limit_scope_to_networks, null) == null ? null : [
            for network_name in try(early_access_features_opt_in.limit_scope_to_networks, []) :
            local.network_ids[format("%s/%s/%s", domain.name, organization.name, network_name)]
          ]
        }
      ]
    ]
  ])
}

resource "meraki_organization_early_access_features_opt_in" "organizations_early_access_features_opt_ins" {
  for_each                = { for v in local.organizations_early_access_features_opt_ins : v.key => v }
  organization_id         = each.value.organization_id
  short_name              = each.value.short_name
  limit_scope_to_networks = each.value.limit_scope_to_networks
}
