locals {
  org_names = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : org.name
    ]
  ])
}

data "meraki_organization" "organization" {
  for_each = toset(local.org_names)
  name     = each.key
}

#  Create a Network
locals {
  networks = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for network in try(org.networks, []) : {
          key             = format("%s/%s/%s", domain.name, org.name, network.name)
          organization_id = data.meraki_organization.organization[org.name].id
          name            = try(network.name, local.defaults.meraki.organizations.networks.name)
          notes           = try(network.notes, local.defaults.meraki.organizations.networks.notes, "")
          product_types   = try(network.product_types, local.defaults.meraki.organizations.networks.product_types, ["appliance", "switch", "wireless"])
          tags            = try(network.tags, local.defaults.meraki.organizations.networks.tags)
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
}

# Apply Organization Login Security Settings
locals {
  login_security = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : {
        organization_id                                     = data.meraki_organization.organization[org.name].id
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
        api_authentication_ip_restrictions_for_keys_enabled = try(org.login_security.api_authentication.ip_restrictions_for_keys.enabled, local.defaults.meraki.organizations.login_security.api_authentication.ip_restrictions_for_keys.enabled, null)
        api_authentication_ip_restrictions_for_keys_ranges  = try(org.login_security.api_authentication.ip_restrictions_for_keys.ranges, local.defaults.meraki.organizations.login_security.api_authentication.ip_restrictions_for_keys.ranges, null)
      } if try(org.login_security, null) != null
    ]
  ])
}


resource "meraki_organization_login_security" "login_security" {
  for_each = { for login in local.login_security : login.organization_id => login }

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
        organization_id = data.meraki_organization.organization[org.name].id
        v2c_enabled     = try(org.snmp.v2c_enabled, local.defaults.meraki.organizations.snmp.v2c_enabled, null)
        v3_enabled      = try(org.snmp.v3_enabled, local.defaults.meraki.organizations.snmp.v3_enabled, null)
        v3_auth_mode    = try(org.snmp.v3_auth_mode, local.defaults.meraki.organizations.snmp.v3_auth_mode, null)
        v3_auth_pass    = try(org.snmp.v3_auth_pass, local.defaults.meraki.organizations.snmp.v3_auth_pass, null)
        v3_priv_mode    = try(org.snmp.v3_priv_mode, local.defaults.meraki.organizations.snmp.v3_priv_mode, null)
        v3_priv_pass    = try(org.snmp.v3_priv_pass, local.defaults.meraki.organizations.snmp.v3_priv_pass, null)
        peer_ips        = try(org.snmp.peer_ips, null)
      }
    ]
  ])
}
resource "meraki_organization_snmp" "snmp" {
  for_each = { for snmp in local.snmp : snmp.organization_id => snmp }

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
//TODO @mcparaf: The logic of this Module is not correct, Networks is nested under Tags in the Data Model.
locals {
  admins = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for admin in try(org.admins, []) : {
          key                   = format("%s/%s", org.name, try(admin.name, local.defaults.meraki.organizations.admins.name, null))
          organization_id       = data.meraki_organization.organization[org.name].id
          name                  = try(admin.name, local.defaults.meraki.organizations.admins.name, null)
          email                 = try(admin.email, local.defaults.meraki.organizations.admins.email, null)
          authentication_method = try(admin.authentication_method, local.defaults.meraki.organizations.admins.authentication_method, null)
          org_access            = try(admin.org_access, local.defaults.meraki.organizations.admins.org_access, null)
          networks = [for network in try(admin.networks, []) : {
            id     = meraki_network.network["${domain.name}/${org.name}/${network.name}"].id
            access = try(network.access, local.defaults.meraki.organizations.admins.networks.access, null)
          }]
          tags = [for tag in try(admin.tags, []) : {
            tag    = tag.name
            access = try(tag.access, local.defaults.meraki.organizations.admins.tags.access, null)
          }]
        }
      ]
    ]
  ])
}
resource "meraki_organization_admin" "organization_admin" {
  for_each              = { for admin in local.admins : admin.key => admin }
  organization_id       = each.value.organization_id
  name                  = each.value.name
  email                 = each.value.email
  authentication_method = each.value.authentication_method
  org_access            = each.value.org_access
  networks              = each.value.networks
  tags                  = each.value.tags
}
# Apply Organization Inventory Claim
locals {
  inventory_claim = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : {
        organization_id = data.meraki_organization.organization[org.name].id
        licenses = [
          for license in try(org.inventory_claim.licenses, []) : {
            key  = license.key
            mode = license.mode
          }
        ]
        orders  = try(org.inventory_claim.orders, [])
        serials = try(org.inventory_claim.serials, [])
      } if try(org.inventory_claim, null) != null
    ]
  ])
}

resource "meraki_organization_inventory_claim" "organization_claim" {
  for_each = { for claim in local.inventory_claim : claim.organization_id => claim }

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

locals {
  adaptive_policy_settings = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : {
        organization_id  = data.meraki_organization.organization[org.name].id
        enabled_networks = try(org.adaptive_policy_settings.enabled_networks, [])
      } if try(org.adaptive_policy_settings, null) != null
    ]
  ])
}

resource "meraki_organization_adaptive_policy_settings" "organization_policy_settings" {
  for_each = { for setting in local.adaptive_policy_settings : setting.organization_id => setting }

  organization_id  = each.value.organization_id
  enabled_networks = each.value.enabled_networks
}

locals {
  adaptive_policy_policies = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for policy in try(org.adaptive_policy_policies, []) : {
          organization_id        = data.meraki_organization.organization[org.name].id
          policy_name            = policy.name
          source_group_id        = policy.source_group.id
          source_group_name      = policy.source_group.name
          source_group_sgt       = policy.source_group.sgt
          destination_group_id   = policy.destination_group.id
          destination_group_name = policy.destination_group.name
          destination_group_sgt  = policy.destination_group.sgt
          acls                   = policy.acls
        }
      ]
    ]
  ])
}

resource "meraki_organization_adaptive_policy" "organization_adaptive_policy" {
  for_each = { for policy in local.adaptive_policy_policies : policy.organization_id => policy }

  organization_id = each.value.organization_id
  # last_entry_rule        = "allow" # This can be changed as per the requirement
  source_group_id        = each.value.source_group_id
  source_group_name      = each.value.source_group_name
  source_group_sgt       = each.value.source_group_sgt
  destination_group_id   = each.value.destination_group_id
  destination_group_name = each.value.destination_group_name
  destination_group_sgt  = each.value.destination_group_sgt
  acls = [
    for acl in each.value.acls : {
      id   = acl.id
      name = acl.name
    }
  ]
}

locals {
  adaptive_policy_groups = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for group in try(org.adaptive_policy_groups, []) : {
          organization_id = data.meraki_organization.organization[org.name].id
          group_name      = group.name
          sgt             = group.sgt
          description     = group.description
          policy_objects  = group.policy_objects
        }
      ]
    ]
  ])
}

resource "meraki_organization_adaptive_policy_group" "organization_adaptive_policy_group" {
  for_each = { for group in local.adaptive_policy_groups : group.organization_id => group }

  organization_id = each.value.organization_id
  name            = each.value.group_name
  sgt             = each.value.sgt
  description     = each.value.description
  policy_objects = [
    for object in each.value.policy_objects : {
      id   = object.id
      name = object.name
    }
  ]
}

locals {
  adaptive_policy_acls = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : [
        for acl in try(org.adaptive_policy_acls, []) : {
          organization_id = data.meraki_organization.organization[org.name].id
          acl_name        = acl.name
          description     = acl.description
          rules           = acl.rules
          ip_version      = acl.ip_version
        }
      ]
    ]
  ])
}

resource "meraki_organization_adaptive_policy_acl" "organization_adaptive_policy_acl" {
  for_each = { for acl in local.adaptive_policy_acls : acl.organization_id => acl }

  organization_id = each.value.organization_id
  name            = each.value.acl_name
  description     = each.value.description
  ip_version      = each.value.ip_version
  rules = [
    for rule in each.value.rules : {
      policy   = rule.policy
      protocol = rule.protocol
      src_port = rule.src_port
      dst_port = rule.dst_port
    }
  ]
}

//TODO @mcparaf: Missing Organization Adaptive Policy
//TODO @mcparaf: Missing Organization Appliance VPN Settings
//TODO @mcparaf: Missing Organization Early Opt-in
//TODO @mcparaf: Missing Organization Policy Objects

