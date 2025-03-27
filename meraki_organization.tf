locals {
  organizations = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : {
        organization_name = org.name,
      }
    ]
  ])
}

# Create Organizations
resource "meraki_organization" "organization" {
  for_each = { for org in local.organizations : org.organization_name => org }
  name     = each.value.organization_name
}

#  Create a Network
locals {
  networks = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          key             = format("%s/%s", org.name, network.name)
          organization_id = meraki_organization.organization[org.name].id
          name            = try(network.name, local.defaults.meraki.organizations.networks.name)
          notes           = try(network.notes, local.defaults.meraki.organizations.networks.notes, "")
          product_types   = try(network.product_types, local.defaults.meraki.organizations.networks.product_types, ["appliance", "switch", "wireless"])
          tags            = try(network.tags, local.defaults.meraki.organizations.networks.tags, null)
          time_zone       = try(network.time_zone, local.defaults.meraki.organizations.networks.time_zone, "America/Los_Angeles")
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
  depends_on = [meraki_organization_inventory_claim.organization_claim,
    meraki_organization.organization
  ]
}

# Apply Organization Login Security Settings
locals {
  login_security = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : {
        organization_id                                     = meraki_organization.organization[org.name].id
        enforce_password_expiration                         = try(org.login_security.enforce_password_expiration, local.defaults.meraki.organizations.login_security.enforce_password_expiration, null)
        password_expiration_days                            = try(org.login_security.password_expiration_days, local.defaults.meraki.organizations.login_security.password_expiration_days, null)
        enforce_different_passwords                         = try(org.login_security.enforce_different_passwords, local.defaults.meraki.organizations.login_security.enforce_different_passwords, null)
        num_different_passwords                             = try(org.login_security.num_different_passwords, local.defaults.meraki.organizations.login_security.num_different_passwords, null)
        enforce_strong_passwords                            = try(org.login_security.enforce_strong_passwords, local.defaults.meraki.organizations.login_security.enforce_strong_passwords, null)
        enforce_account_lockout                             = try(org.login_security.enforce_account_lockout, local.defaults.meraki.organizations.login_security.enforce_account_lockout, null)
        account_lockout_attempts                            = try(org.login_security.account_lockout_attempts, local.defaults.meraki.organizations.login_security.account_lockout_attempts, null)
        enforce_idle_timeout                                = try(org.login_security.enforce_idle_timeout, local.defaults.meraki.organizations.login_security.enforce_idle_timeout, null)
        idle_timeout_minutes                                = try(org.login_security.idle_timeout_minutes, local.defaults.meraki.organizations.login_security.idle_timeout_minutes, null)
        enforce_two_factor_auth                             = try(org.login_security.enforce_two_factor_auth, local.defaults.meraki.organizations.login_security.enforce_two_factor_auth, null)
        enforce_login_ip_ranges                             = try(org.login_security.enforce_login_ip_ranges, local.defaults.meraki.organizations.login_security.enforce_login_ip_ranges, null)
        login_ip_ranges                                     = try(org.login_security.login_ip_ranges, local.defaults.meraki.organizations.login_security.login_ip_ranges, null)
        api_authentication_ip_restrictions_for_keys_enabled = try(org.login_security.api_authentication.enabled, local.defaults.meraki.organizations.login_security.api_authentication.enabled, null)
        api_authentication_ip_restrictions_for_keys_ranges  = try(org.login_security.api_authentication.ranges, local.defaults.meraki.organizations.login_security.api_authentication.ranges, null)
      } if try(org.login_security, null) != null
    ]
  ])
}


resource "meraki_organization_login_security" "login_security" {
  for_each                                            = { for i, v in local.login_security : i => v }
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
      for org in try(domain.organizations, []) : {
        organization_id = meraki_organization.organization[org.name].id
        v2c             = try(org.snmp.v2c, local.defaults.meraki.organizations.snmp.v2c, null)
        v3              = try(org.snmp.v3, local.defaults.meraki.organizations.snmp.v3, null)
        v3_auth_mode    = try(org.snmp.v3_auth_mode, local.defaults.meraki.organizations.snmp.v3_auth_mode, null)
        v3_auth_pass    = try(org.snmp.v3_auth_pass, local.defaults.meraki.organizations.snmp.v3_auth_pass, null)
        v3_priv_mode    = try(org.snmp.v3_priv_mode, local.defaults.meraki.organizations.snmp.v3_priv_mode, null)
        v3_priv_pass    = try(org.snmp.v3_priv_pass, local.defaults.meraki.organizations.snmp.v3_priv_pass, null)
        peer_ips        = try(org.snmp.peer_ips, null)
      } if try(org.snmp, null) != null
    ]
  ])
}
resource "meraki_organization_snmp" "snmp" {
  for_each        = { for i, v in local.snmp : i => v }
  organization_id = each.value.organization_id
  v2c_enabled     = each.value.v2c
  v3_enabled      = each.value.v3
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
      for org in try(domain.organizations, []) : [
        for admin in try(org.admins, []) : {
          key             = format("%s/%s", org.name, try(admin.name, local.defaults.meraki.organizations.admins.name, null))
          organization_id = meraki_organization.organization[org.name].id
          name            = try(admin.name, local.defaults.meraki.organizations.admins.name, null)
          email           = try(admin.email, local.defaults.meraki.organizations.admins.email, null)
          # authentication_method = try(admin.authentication_method, local.defaults.meraki.organizations.admins.authentication_method, null)
          org_access = try(admin.organization_access, local.defaults.meraki.organizations.admins.organization_access, null)
          networks = [for network in try(admin.networks, []) : {
            id     = meraki_network.network["${org.name}/${network.id}"].id
            access = try(network.access, local.defaults.meraki.organizations.admins.networks.access, null)
          }]
          tags = [for tag in try(admin.tags, []) : {
            tag    = tag.tag
            access = try(tag.access, local.defaults.meraki.organizations.admins.tags.access, null)
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
      for org in try(domain.organizations, []) : {
        organization_id = meraki_organization.organization[org.name].id
        licenses = [
          for license in try(org.inventory.licenses, []) : {
            key  = license.key
            mode = license.mode
          }
        ]
        orders  = try(org.inventory.orders, [])
        serials = try(org.inventory.serials, [])
      } if try(org.inventory, null) != null
    ]
  ])
}

resource "meraki_organization_inventory_claim" "organization_claim" {
  for_each        = { for i, v in local.inventory : i => v }
  organization_id = each.value.organization_id
  licenses = [
    for license in each.value.licenses : {
      key  = license.key
      mode = license.mode
    }
  ]
  orders  = each.value.orders
  serials = each.value.serials
}
# Apply Organization Adaptive Policy Settings
# Use existing network data in adaptive policy settings
locals {
  adaptive_policy_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : {
        org_id = meraki_organization.organization[organization.name].id
        enabled_networks = [
          for network in try(organization.adaptive_policy.settings.enabled_networks, []) :
          meraki_network.network[format("%s/%s", organization.name, network)].id
        ]
      } if try(organization.adaptive_policy.settings, null) != null
    ] if try(domain.organizations, null) != null
  ])
}

resource "meraki_organization_adaptive_policy_settings" "organizations_adaptive_policy_settings" {
  for_each         = { for i, v in local.adaptive_policy_settings : i => v }
  organization_id  = each.value.org_id
  enabled_networks = each.value.enabled_networks
  depends_on       = [meraki_network.network]
}
# Apply Organization Adaptive Policy
locals {
  adaptive_policy_groups = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for group in try(organization.adaptive_policy.groups, []) : {
          org_id      = meraki_organization.organization[organization.name].id
          key         = format("%s/adaptive_policy_groups/%s", organization.name, group.name)
          group_name  = try(group.name, local.defaults.meraki.organizations.adaptive_policy.groups.name, null)
          sgt         = try(group.sgt, local.defaults.meraki.organizations.adaptive_policy.groups.sgt, null)
          description = try(group.description, local.defaults.meraki.organizations.adaptive_policy.groups.description, null)
        } if try(organization.adaptive_policy.groups, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
  adaptive_policy_acls = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for acl in try(organization.adaptive_policy.acls, []) : {
          org_id      = meraki_organization.organization[organization.name].id
          acl_name    = try(acl.name, local.defaults.meraki.organizations.adaptive_policy.acls.name, null)
          description = try(acl.description, local.defaults.meraki.organizations.adaptive_policy.acls.description, null)
          rules       = try(acl.rules, local.defaults.meraki.organizations.adaptive_policy.acls.rules, [])
          ip_version  = try(acl.ip_version, local.defaults.meraki.organizations.adaptive_policy.acls.ip_version, null)
          key         = format("%s/adaptive_policy_acls/%s", organization.name, acl.name)
        } if try(organization.adaptive_policy.acls, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
  adaptive_policies = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for policy in try(organization.adaptive_policy.policies, []) : {
          org_id                 = meraki_organization.organization[organization.name].id
          policy_name            = try(policy.name, local.defaults.meraki.organizations.adaptive_policy.policies.name, null)
          source_group_name      = try(policy.source_group.name, local.defaults.meraki.organizations.adaptive_policy.policies.source_group.name, null)
          source_group_sgt       = try(policy.source_group.sgt, local.defaults.meraki.organizations.adaptive_policy.policies.source_group.sgt, null)
          source_group_id        = meraki_organization_adaptive_policy_group.organizations_adaptive_policy_group[format("%s/adaptive_policy_groups/%s", organization.name, policy.source_group.name)].id
          destination_group_name = try(policy.destination_group.name, local.defaults.meraki.organizations.adaptive_policy.policies.destination_group.name, null)
          destination_group_sgt  = try(policy.destination_group.sgt, local.defaults.meraki.organizations.adaptive_policy.policies.destination_group.sgt, null)
          destination_group_id   = meraki_organization_adaptive_policy_group.organizations_adaptive_policy_group[format("%s/adaptive_policy_groups/%s", organization.name, policy.destination_group.name)].id
          last_entry_rule        = try(policy.last_entry_rule, local.defaults.meraki.organizations.adaptive_policy.policies.last_entry_rule, null)
          acls = [
            for acl in policy.acls : {
              id   = meraki_organization_adaptive_policy_acl.organizations_adaptive_policy_acl[format("%s/adaptive_policy_acls/%s", organization.name, acl)].id
              name = acl
            }
          ]
        } if try(organization.adaptive_policy.policies, null) != null
      ] if try(domain.organizations, null) != null
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_organization_adaptive_policy_group" "organizations_adaptive_policy_group" {
  for_each        = { for g in local.adaptive_policy_groups : g.key => g }
  organization_id = each.value.org_id
  name            = each.value.group_name
  sgt             = each.value.sgt
  description     = each.value.description
}

resource "meraki_organization_adaptive_policy_acl" "organizations_adaptive_policy_acl" {
  for_each        = { for i in local.adaptive_policy_acls : i.key => i }
  organization_id = each.value.org_id
  name            = each.value.acl_name
  description     = each.value.description
  ip_version      = each.value.ip_version
  rules = [
    for rule in each.value.rules : {
      policy   = try(rule.policy, local.defaults.meraki.organizations.adaptive_policy.acls.rule.policy, null)
      protocol = try(rule.protocol, local.defaults.meraki.organizations.adaptive_policy.acls.rule.protocol, null)
      src_port = try(rule.source_port, local.defaults.meraki.organizations.adaptive_policy.acls.rule.source_port, null)
      dst_port = try(rule.destination_port, local.defaults.meraki.organizations.adaptive_policy.acls.rule.destination_port, null)
    }
  ]
  depends_on = [meraki_organization_adaptive_policy_group.organizations_adaptive_policy_group]
}

resource "meraki_organization_adaptive_policy" "organizations_adaptive_policy_policy" {
  for_each               = { for i, v in local.adaptive_policies : i => v }
  organization_id        = each.value.org_id
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
          org_id   = meraki_organization.organization[organization.name].id
          key      = "${organization.name}/${obj.name}"
          name     = try(obj.name, local.defaults.meraki.organizations.adaptive_policy_object.name, null)
          category = try(obj.category, local.defaults.meraki.organizations.adaptive_policy_object.category, null)
          type     = try(obj.type, local.defaults.meraki.organizations.adaptive_policy_object.type, null)
          cidr     = try(obj.cidr, local.defaults.meraki.organizations.adaptive_policy_object.cidr, null)
          fqdn     = try(obj.fqdn, local.defaults.meraki.organizations.adaptive_policy_object.fqdn, null)
          mask     = try(obj.mask, local.defaults.meraki.organizations.adaptive_policy_object.mask, null)
          ip       = try(obj.ip, local.defaults.meraki.organizations.adaptive_policy_object.ip, null)
        } if try(organization.policy_objects, null) != null
      ]
    ]
  ])
}

# Create Policy Objects
resource "meraki_organization_policy_object" "policy_object" {
  for_each        = { for obj in local.policy_objects : obj.key => obj }
  organization_id = each.value.org_id
  category        = each.value.category
  name            = each.value.name
  type            = each.value.type
  cidr            = try(each.value.cidr, null)
  fqdn            = try(each.value.fqdn, null)
  mask            = try(each.value.mask, null)
  ip              = try(each.value.ip, null)
}
locals {
  policy_object_groups = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : [
        for group in try(organization.policy_objects_groups, []) : {
          org_id     = meraki_organization.organization[organization.name].id
          name       = group.name
          key        = "${organization.name}/${group.name}"
          category   = group.category
          object_ids = [for name in try(group.object_names, []) : meraki_organization_policy_object.policy_object["${organization.name}/${name}"].id]
        } if try(organization.policy_objects_groups, null) != null
      ]
    ]
  ])
}

# Create Policy Object Groups (if applicable)
resource "meraki_organization_policy_object_group" "policy_object_group" {
  for_each        = { for group in local.policy_object_groups : group.key => group }
  organization_id = each.value.org_id
  name            = each.value.name
  category        = each.value.category
  object_ids      = each.value.object_ids
}
locals {
  networks_organizations_appliance_third_party_vpn_peers = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : {
        org_id = meraki_organization.organization[organization.name].id
        peers = [
          for peer in try(organization.appliance.third_party_vpn_peers, []) : {
            name                                    = try(peer.name, null)
            public_ip                               = try(peer.public_ip, null)
            remote_id                               = try(peer.remote_id, null)
            secret                                  = try(peer.secret, null)
            ike_version                             = try(peer.ike_version, null)
            local_id                                = try(peer.local_id, null)
            private_subnets                         = try(peer.private_subnets, null)
            network_tags                            = try(peer.network_tags, null)
            ipsec_policies_ike_cipher_algo          = try(peer.ipsec_policies.ike_cipher_algo, null)
            ipsec_policies_ike_auth_algo            = try(peer.ipsec_policies.ike_auth_algo, null)
            ipsec_policies_ike_prf_algo             = try(peer.ipsec_policies.ike_prf_algo, null)
            ipsec_policies_ike_diffie_hellman_group = try(peer.ipsec_policies.ike_diffie_hellman_group, null)
            ipsec_policies_ike_lifetime             = try(peer.ipsec_policies.ike_lifetime, null)
            ipsec_policies_child_cipher_algo        = try(peer.ipsec_policies.child_cipher_algo, null)
            ipsec_policies_child_auth_algo          = try(peer.ipsec_policies.child_auth_algo, null)
            ipsec_policies_child_pfs_group          = try(peer.ipsec_policies.child_pfs_group, null)
            ipsec_policies_child_lifetime           = try(peer.ipsec_policies.child_lifetime, null)
          }
        ]
      } if length(try(organization.appliance.third_party_vpn_peers, [])) > 0
    ] if try(local.meraki.domains, null) != null
  ])
}

resource "meraki_appliance_third_party_vpn_peers" "organizations_appliance_third_party_vpn_peers" {
  for_each        = { for i, v in local.networks_organizations_appliance_third_party_vpn_peers : i => v }
  organization_id = each.value.org_id
  peers           = length(each.value.peers) > 0 ? each.value.peers : null
  depends_on      = [meraki_network.network]
}

locals {
  networks_organizations_appliance_vpn_firewall_rules = flatten([
    for domain in try(local.meraki.domains, []) : [
      for organization in try(domain.organizations, []) : {
        org_id = meraki_organization.organization[organization.name].id
        rules = [
          for rule in try(organization.appliance.vpn_firewall_rules.rules, []) : {
            comment        = try(rule.comment, null)
            policy         = try(rule.policy, null)
            protocol       = try(rule.protocol, null)
            src_port       = try(rule.source_port, null)
            src_cidr       = try(rule.source_cidr, null)
            dest_port      = try(rule.destination_port, null)
            dest_cidr      = try(rule.destination_cidr, null)
            syslog_enabled = try(rule.syslog, null)
          }
        ]
      } if length(try(organization.appliance.vpn_firewall_rules.rules, [])) > 0
    ] if try(local.meraki.domains, null) != null
  ])
}
resource "meraki_appliance_vpn_firewall_rules" "organizations_vpn_firewall_rules" {
  for_each        = { for i, v in local.networks_organizations_appliance_vpn_firewall_rules : i => v }
  organization_id = each.value.org_id
  rules           = length(each.value.rules) > 0 ? each.value.rules : null
  depends_on      = [meraki_network.network]
}
