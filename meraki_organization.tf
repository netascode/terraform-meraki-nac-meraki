data "meraki_organizations" "organizations" {
}
#  Create a Network
locals {
  organization_map = { for organization in data.meraki_organizations.organizations.items : organization.name => organization.id }
  networks = flatten([
  for domain in try(local.meraki.domains, []) : [
    for org in try(domain.organizations, []) : [
      for network in try(org.networks, []) : {
        key             = format("%s/%s/%s", domain.name, org.name, network.name)
        organization_id = local.organization_map[org.name]
        name            = try(network.name, local.defaults.meraki.organizations.networks.name)
        notes           = try(network.notes, local.defaults.meraki.organizations.networks.notes)
        product_types   = try(network.product_types, local.defaults.meraki.organizations.networks.product_types)
        tags            = try(network.tags, local.defaults.meraki.organizations.networks.tags)
        time_zone       = try(network.timezone, local.defaults.meraki.organizations.networks.timezone)
      }
    ]
  ]
  ])
}
resource "meraki_networks" "networks" {
  for_each = { for network in local.networks : network.key => network }
  name            = each.value.name
  notes           = each.value.notes
  organization_id = each.value.organization_id
  product_types   = each.value.product_types
  tags            = each.value.tags
  time_zone       = each.value.time_zone
}
locals {
  login_security = flatten([
    for domain in try(local.meraki.domains, []) : [
      for org in try(domain.organizations, []) : {
        organization_id             = local.organization_map[org.name]
        enforce_password_expiration = try(org.login_security.enforce_password_expiration, local.defaults.meraki.organizations.login_security.enforce_password_expiration)
        password_expiration_days    = try(org.login_security.password_expiration_days, local.defaults.meraki.organizations.login_security.password_expiration_days)
        enforce_different_passwords = try(org.login_security.enforce_different_passwords, local.defaults.meraki.organizations.login_security.enforce_different_passwords)
        num_different_passwords     = try(org.login_security.num_different_passwords, local.defaults.meraki.organizations.login_security.num_different_passwords)
        enforce_strong_passwords    = try(org.login_security.enforce_strong_passwords, local.defaults.meraki.organizations.login_security.enforce_strong_passwords)
        enforce_account_lockout     = try(org.login_security.enforce_account_lockout, local.defaults.meraki.organizations.login_security.enforce_account_lockout)
        account_lockout_attempts    = try(org.login_security.account_lockout_attempts, local.defaults.meraki.organizations.login_security.account_lockout_attempts)
        enforce_idle_timeout        = try(org.login_security.enforce_idle_timeout, local.defaults.meraki.organizations.login_security.enforce_idle_timeout)
        idle_timeout_minutes        = try(org.login_security.idle_timeout_minutes, local.defaults.meraki.organizations.login_security.idle_timeout_minutes)
        enforce_two_factor_auth     = try(org.login_security.enforce_two_factor_auth, local.defaults.meraki.organizations.login_security.enforce_two_factor_auth)
        enforce_login_ip_ranges     = try(org.login_security.enforce_login_ip_ranges, local.defaults.meraki.organizations.login_security.enforce_login_ip_ranges)
        login_ip_ranges             = try(org.login_security.login_ip_ranges, local.defaults.meraki.organizations.login_security.login_ip_ranges)
      }
    ]
  ])
}


resource "meraki_organizations_login_security" "login_security" {
  for_each = { for login in local.login_security : login.organization_id => login }

  organization_id             = each.value.organization_id
  enforce_password_expiration = each.value.enforce_password_expiration
  password_expiration_days    = each.value.password_expiration_days
  enforce_different_passwords = each.value.enforce_different_passwords
  num_different_passwords     = each.value.num_different_passwords
  enforce_strong_passwords    = each.value.enforce_strong_passwords
  enforce_account_lockout     = each.value.enforce_account_lockout
  account_lockout_attempts    = each.value.account_lockout_attempts
  enforce_idle_timeout        = each.value.enforce_idle_timeout
  idle_timeout_minutes        = each.value.idle_timeout_minutes
  enforce_two_factor_auth     = each.value.enforce_two_factor_auth
  enforce_login_ip_ranges     = each.value.enforce_login_ip_ranges
  login_ip_ranges             = each.value.login_ip_ranges
}


# # Apply Org Wide Administrator Users
# locals {
#   admins = flatten([
#   for domain in try(local.meraki.domains, []) : [
#     for org in try(domain.organizations, []) : [
#       for admin in try(org.administrators, []) : {
#         # key                   = format("%s/%s", org.name, admin.name)
#         organization_id       = local.organization_map[org.name]
#         name                  = try(admin.name, local.defaults.meraki.organizations.administrators.name)
#         email                 = try(admin.email, local.defaults.meraki.organizations.administrators.email)
#         authentication_method = try(admin.authentication_method, local.defaults.meraki.organizations.administrators.authentication_method)
#         org_access            = try(admin.organization_access, local.defaults.meraki.organizations.administrators.organization_access)
#         networks = [for network in try(admin.networks, []) : {
#           id     = meraki_networks.networks["${org.name}/${network.name}"].id
#           access = try(network.access, local.defaults.meraki.organizations.administrators.networks.access)
#         }]
#         tags = [for tag in try(admin.tags, []) : {
#           tag    = tag.name
#           access = try(tag.access, local.defaults.meraki.organizations.administrators.tags.access)
#         }]
#       }
#     ]
#   ]
#   ])
# }

# resource "meraki_organizations_admins" "organizations_admins" {
#   for_each = { for idx, admin in local.admins : "${admin.organization_id}_${idx}" => admin }
#   # for_each = { for admin in local.admins : admin.key => admin }
#   organization_id       = each.value.organization_id
#   name                  = each.value.name
#   email                 = each.value.email
#   authentication_method = each.value.authentication_method
#   org_access            = each.value.org_access
#   networks              = each.value.networks
#   tags                  = each.value.tags
# }
