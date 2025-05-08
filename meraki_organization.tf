locals {
  organizations = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : {
        key     = format("%s/%s", domain.name, organization.name)
        name    = try(organization.name, local.defaults.meraki.domains.organizations.name, null)
        managed = try(organization.managed, local.defaults.meraki.domains.organizations.managed, true)
        management_details = try(length(organization.management) == 0, true) ? null : [
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

# Create Organizations
resource "meraki_organization" "organization" {
  for_each           = { for organization in local.managed_organizations : organization.key => organization }
  name               = each.value.name
  management_details = each.value.management_details
}

data "meraki_organization" "organization" {
  for_each = { for organization in local.unmanaged_organizations : organization.key => organization }
  name     = each.value.name
}

locals {
  organization_ids = {
    for organization in local.organizations :
    organization.key =>
    organization.managed ?
    meraki_organization.organization[organization.key].id :
    data.meraki_organization.organization[organization.key].id
  }
}

#  Create a Network
locals {
  networks = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for network in try(organization.networks, []) : {
          key             = format("%s/%s/%s", domain.name, organization.name, network.name)
          organization_id = local.organization_ids[format("%s/%s", domain.name, organization.name)]
          name            = try(network.name, local.defaults.meraki.domains.organizations.networks.name)
          notes           = try(network.notes, local.defaults.meraki.domains.organizations.networks.notes, "")
          product_types   = try(network.product_types, local.defaults.meraki.domains.organizations.networks.product_types, ["appliance", "switch", "wireless"])
          tags            = try(network.tags, local.defaults.meraki.domains.organizations.networks.tags, null)
          time_zone       = try(network.time_zone, local.defaults.meraki.domains.organizations.networks.time_zone, "America/Los_Angeles")
        }
      ]
    ]
  ])
}

resource "meraki_network" "network" {
  for_each        = { for network in local.networks : network.key => network }
  name            = each.value.name
  notes           = each.value.notes
  organization_id = each.value.organization_id
  product_types   = each.value.product_types
  tags            = each.value.tags
  time_zone       = each.value.time_zone
  depends_on = [
    meraki_organization_inventory_claim.organization_claim,
    meraki_organization.organization
  ]
}

# Apply Organization Login Security Settings
locals {
  login_security = flatten([
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

resource "meraki_organization_login_security" "login_security" {
  for_each                                            = { for v in local.login_security : v.key => v }
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

# Apply Organization SNMP Settings
locals {
  snmp = flatten([
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

resource "meraki_organization_snmp" "snmp" {
  for_each        = { for v in local.snmp : v.key => v }
  organization_id = each.value.organization_id
  v2c_enabled     = each.value.v2c_enabled
  v3_enabled      = each.value.v3_enabled
  v3_auth_mode    = each.value.v3_auth_mode
  v3_auth_pass    = each.value.v3_auth_pass
  v3_priv_mode    = each.value.v3_priv_mode
  v3_priv_pass    = each.value.v3_priv_pass
  peer_ips        = each.value.peer_ips
}

# Apply Organization Admins
locals {
  admins = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for admin in try(organization.admins, []) : {
          key             = format("%s/%s/%s", domain.name, organization.name, try(admin.name, local.defaults.meraki.domains.organizations.admins.name, null))
          organization_id = local.organization_ids[format("%s/%s", domain.name, organization.name)]
          name            = try(admin.name, local.defaults.meraki.domains.organizations.admins.name, null)
          email           = try(admin.email, local.defaults.meraki.domains.organizations.admins.email, null)
          # authentication_method = try(admin.authentication_method, local.defaults.meraki.domains.organizations.admins.authentication_method, null)
          org_access = try(admin.organization_access, local.defaults.meraki.domains.organizations.admins.organization_access, null)
          networks = try(length(admin.networks) == 0, true) ? null : [for network in try(admin.networks, []) : {
            id     = meraki_network.network[format("%s/%s/%s", domain.name, organization.name, network.name)].id
            access = try(network.access, local.defaults.meraki.domains.organizations.admins.networks.access, null)
          }]
          tags = try(length(admin.tags) == 0, true) ? null : [for tag in try(admin.tags, []) : {
            tag    = tag.tag
            access = try(tag.access, local.defaults.meraki.domains.organizations.admins.tags.access, null)
          }]
        }
      ]
    ]
  ])
}

resource "meraki_organization_admin" "organization_admin" {
  for_each        = { for admin in local.admins : admin.key => admin }
  organization_id = each.value.organization_id
  name            = each.value.name
  email           = each.value.email
  # authentication_method = each.value.authentication_method
  org_access = each.value.org_access
  networks   = each.value.networks
  tags       = each.value.tags
}

# Apply Organization Inventory
locals {
  inventory = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : {
        key             = format("%s/%s", domain.name, organization.name)
        organization_id = local.organization_ids[format("%s/%s", domain.name, organization.name)]
        licenses = try(length(organization.inventory.licenses) == 0, true) ? null : [
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

resource "meraki_organization_inventory_claim" "organization_claim" {
  for_each        = { for v in local.inventory : v.key => v }
  organization_id = each.value.organization_id
  licenses        = each.value.licenses
  orders          = each.value.orders
  serials         = each.value.serials
}

# Apply Organization Adaptive Policy Settings
# Use existing network data in adaptive policy settings
locals {
  adaptive_policy_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : {
        key             = format("%s/%s", domain.name, organization.name)
        organization_id = local.organization_ids[format("%s/%s", domain.name, organization.name)]
        enabled_networks = try(length(organization.adaptive_policy.settings.enabled_networks) == 0, true) ? null : [
          for network in try(organization.adaptive_policy.settings.enabled_networks, []) :
          meraki_network.network[format("%s/%s/%s", domain.name, organization.name, network)].id
        ]
      } if try(organization.adaptive_policy.settings, null) != null
    ]
  ])
}

resource "meraki_organization_adaptive_policy_settings" "organizations_adaptive_policy_settings" {
  for_each         = { for v in local.adaptive_policy_settings : v.key => v }
  organization_id  = each.value.organization_id
  enabled_networks = each.value.enabled_networks
  depends_on       = [meraki_network.network]
}
# Apply Organization Adaptive Policy
locals {
  adaptive_policy_groups = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for group in try(organization.adaptive_policy.groups, []) : {
          key             = format("%s/%s/%s", domain.name, organization.name, group.name)
          organization_id = local.organization_ids[format("%s/%s", domain.name, organization.name)]
          group_name      = try(group.name, local.defaults.meraki.domains.organizations.adaptive_policy.groups.name, null)
          sgt             = try(group.sgt, local.defaults.meraki.domains.organizations.adaptive_policy.groups.sgt, null)
          description     = try(group.description, local.defaults.meraki.domains.organizations.adaptive_policy.groups.description, null)
        }
      ]
    ]
  ])
}

resource "meraki_organization_adaptive_policy_group" "organizations_adaptive_policy_group" {
  for_each        = { for g in local.adaptive_policy_groups : g.key => g }
  organization_id = each.value.organization_id
  name            = each.value.group_name
  sgt             = each.value.sgt
  description     = each.value.description
}

locals {
  adaptive_policy_acls = flatten([
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

resource "meraki_organization_adaptive_policy_acl" "organizations_adaptive_policy_acl" {
  for_each        = { for i in local.adaptive_policy_acls : i.key => i }
  organization_id = each.value.organization_id
  name            = each.value.name
  description     = each.value.description
  rules           = each.value.rules
  ip_version      = each.value.ip_version
  depends_on      = [meraki_organization_adaptive_policy_group.organizations_adaptive_policy_group]
}

locals {
  adaptive_policies = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for policy in try(organization.adaptive_policy.policies, []) : {
          key                    = format("%s/%s/%s", domain.name, organization.name, policy.name)
          organization_id        = local.organization_ids[format("%s/%s", domain.name, organization.name)]
          policy_name            = try(policy.name, local.defaults.meraki.domains.organizations.adaptive_policy.policies.name, null)
          source_group_name      = try(policy.source_group.name, local.defaults.meraki.domains.organizations.adaptive_policy.policies.source_group.name, null)
          source_group_sgt       = try(policy.source_group.sgt, local.defaults.meraki.domains.organizations.adaptive_policy.policies.source_group.sgt, null)
          source_group_id        = meraki_organization_adaptive_policy_group.organizations_adaptive_policy_group[format("%s/%s/%s", domain.name, organization.name, policy.source_group.name)].id
          destination_group_name = try(policy.destination_group.name, local.defaults.meraki.domains.organizations.adaptive_policy.policies.destination_group.name, null)
          destination_group_sgt  = try(policy.destination_group.sgt, local.defaults.meraki.domains.organizations.adaptive_policy.policies.destination_group.sgt, null)
          destination_group_id   = meraki_organization_adaptive_policy_group.organizations_adaptive_policy_group[format("%s/%s/%s", domain.name, organization.name, policy.destination_group.name)].id
          last_entry_rule        = try(policy.last_entry_rule, local.defaults.meraki.domains.organizations.adaptive_policy.policies.last_entry_rule, null)
          acls = try(length(policy.acls) == 0, true) ? null : [
            for acl in policy.acls : {
              id   = meraki_organization_adaptive_policy_acl.organizations_adaptive_policy_acl[format("%s/%s/%s", domain.name, organization.name, acl)].id
              name = acl
            }
          ]
        }
      ]
    ]
  ])
}

resource "meraki_organization_adaptive_policy" "organizations_adaptive_policy_policy" {
  for_each               = { for v in local.adaptive_policies : v.key => v }
  organization_id        = each.value.organization_id
  source_group_id        = each.value.source_group_id
  source_group_name      = each.value.source_group_name
  source_group_sgt       = each.value.source_group_sgt
  destination_group_id   = each.value.destination_group_id
  destination_group_name = each.value.destination_group_name
  destination_group_sgt  = each.value.destination_group_sgt
  acls                   = each.value.acls
  last_entry_rule        = each.value.last_entry_rule
  depends_on = [
    meraki_organization_adaptive_policy_group.organizations_adaptive_policy_group,
    meraki_organization_adaptive_policy_acl.organizations_adaptive_policy_acl
  ]
}

locals {
  policy_objects = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for obj in try(organization.policy_objects, []) : {
          key             = format("%s/%s/%s", domain.name, organization.name, obj.name)
          organization_id = local.organization_ids[format("%s/%s", domain.name, organization.name)]
          name            = try(obj.name, local.defaults.meraki.domains.organizations.adaptive_policy_object.name, null)
          category        = try(obj.category, local.defaults.meraki.domains.organizations.adaptive_policy_object.category, null)
          type            = try(obj.type, local.defaults.meraki.domains.organizations.adaptive_policy_object.type, null)
          cidr            = try(obj.cidr, local.defaults.meraki.domains.organizations.adaptive_policy_object.cidr, null)
          fqdn            = try(obj.fqdn, local.defaults.meraki.domains.organizations.adaptive_policy_object.fqdn, null)
          mask            = try(obj.mask, local.defaults.meraki.domains.organizations.adaptive_policy_object.mask, null)
          ip              = try(obj.ip, local.defaults.meraki.domains.organizations.adaptive_policy_object.ip, null)
        }
      ]
    ]
  ])
}

# Create Policy Objects
resource "meraki_organization_policy_object" "policy_object" {
  for_each        = { for obj in local.policy_objects : obj.key => obj }
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
  policy_object_groups = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for group in try(organization.policy_objects_groups, []) : {
          key             = format("%s/%s/%s", domain.name, organization.name, group.name)
          organization_id = local.organization_ids[format("%s/%s", domain.name, organization.name)]
          name            = try(group.name, local.defaults.meraki.domains.organizations.policy_objects_groups.name, null)
          category        = try(group.category, local.defaults.meraki.domains.organizations.policy_objects_groups.category, null)
          object_ids = try(length(group.object_names) == 0, true) ? null : [
            for name in try(group.object_names, []) : meraki_organization_policy_object.policy_object[format("%s/%s/%s", domain.name, organization.name, name)].id
          ]
        }
      ]
    ]
  ])
}

# Create Policy Object Groups (if applicable)
resource "meraki_organization_policy_object_group" "policy_object_group" {
  for_each        = { for group in local.policy_object_groups : group.key => group }
  organization_id = each.value.organization_id
  name            = each.value.name
  category        = each.value.category
  object_ids      = each.value.object_ids
}

locals {
  networks_organizations_appliance_third_party_vpn_peers = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : {
        key             = format("%s/%s", domain.name, organization.name)
        organization_id = local.organization_ids[format("%s/%s", domain.name, organization.name)]
        peers = try(length(organization.appliance.third_party_vpn_peers) == 0, true) ? null : [
          for peer in try(organization.appliance.third_party_vpn_peers, []) : {
            name                                    = try(peer.name, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.name, null)
            public_ip                               = try(peer.public_ip, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.public_ip, null)
            remote_id                               = try(peer.remote_id, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.remote_id, null)
            secret                                  = try(peer.secret, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.secret, null)
            ike_version                             = try(peer.ike_version, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.ike_version, null)
            local_id                                = try(peer.local_id, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.local_id, null)
            private_subnets                         = try(peer.private_subnets, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.private_subnets, null)
            network_tags                            = try(peer.network_tags, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.network_tags, null)
            ipsec_policies_ike_cipher_algo          = try(peer.ipsec_policies.ike_cipher_algo, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.ipsec_policies.ike_cipher_algo, null)
            ipsec_policies_ike_auth_algo            = try(peer.ipsec_policies.ike_auth_algo, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.ipsec_policies.ike_auth_algo, null)
            ipsec_policies_ike_prf_algo             = try(peer.ipsec_policies.ike_prf_algo, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.ipsec_policies.ike_prf_algo, null)
            ipsec_policies_ike_diffie_hellman_group = try(peer.ipsec_policies.ike_diffie_hellman_group, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.ipsec_policies.ike_diffie_hellman_group, null)
            ipsec_policies_ike_lifetime             = try(peer.ipsec_policies.ike_lifetime, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.ipsec_policies.ike_lifetime, null)
            ipsec_policies_child_cipher_algo        = try(peer.ipsec_policies.child_cipher_algo, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.ipsec_policies.child_cipher_algo, null)
            ipsec_policies_child_auth_algo          = try(peer.ipsec_policies.child_auth_algo, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.ipsec_policies.child_auth_algo, null)
            ipsec_policies_child_pfs_group          = try(peer.ipsec_policies.child_pfs_group, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.ipsec_policies.child_pfs_group, null)
            ipsec_policies_child_lifetime           = try(peer.ipsec_policies.child_lifetime, local.defaults.meraki.domains.organizations.appliance.third_party_vpn_peers.ipsec_policies.child_lifetime, null)
          }
        ]
      } if length(try(organization.appliance.third_party_vpn_peers, [])) > 0
    ]
  ])
}

resource "meraki_appliance_third_party_vpn_peers" "organizations_appliance_third_party_vpn_peers" {
  for_each        = { for v in local.networks_organizations_appliance_third_party_vpn_peers : v.key => v }
  organization_id = each.value.organization_id
  peers           = each.value.peers
  depends_on      = [meraki_network.network]
}

locals {
  networks_organizations_appliance_vpn_firewall_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : {
        key             = format("%s/%s", domain.name, organization.name)
        organization_id = local.organization_ids[format("%s/%s", domain.name, organization.name)]
        rules = try(length(organization.appliance.vpn_firewall_rules.rules) == 0, true) ? null : [
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
      } if length(try(organization.appliance.vpn_firewall_rules.rules, [])) > 0
    ]
  ])
}

resource "meraki_appliance_vpn_firewall_rules" "organizations_vpn_firewall_rules" {
  for_each        = { for v in local.networks_organizations_appliance_vpn_firewall_rules : v.key => v }
  organization_id = each.value.organization_id
  rules           = each.value.rules
  depends_on      = [meraki_network.network]
}
