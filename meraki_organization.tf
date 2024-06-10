data "meraki_organizations" "organizations" {
  organization_id = "1575199"
}
output "test" {
  value = data.meraki_organizations.organizations.item.name
}
locals {
  organization_map = { for organization in data.meraki_organizations.organizations.items : organization.name => organization.id }
  networks = flatten([
    for org in try(local.meraki.domains.organizations, []) : [
      for network in try(org.networks, []) : {
        key             = format("%s/%s", org.name, network.name)
        organization_id = local.organization_map[org.name]
        name            = try(network.name, local.defaults.meraki.organizations.networks.name)
        notes           = try(network.notes, local.defaults.meraki.organizations.networks.notes)
        product_types   = try(network.product_types, local.defaults.meraki.organizations.networks.product_types)
        tags            = try(network.tags, local.defaults.meraki.organizations.networks.tags)
        time_zone       = try(network.timezone, local.defaults.meraki.organizations.networks.timezone)
      }
    ]
  ])
}
# output "meraki_domains_organizations" {
#     description = "Output the value of local.meraki.domains.organizations for debugging"
#     value       = local.meraki.domains.organizations
# }

# output "organization_map" {
#     description = "Output the value of local.organization_map for debugging"
#     value       = local.organization_map
# }

# output "networks" {
#     description = "Output the value of local.networks for debugging"
#     value       = local.networks
# }
resource "meraki_networks" "networks" {
  for_each = { for network in local.networks : network.key => network }

  name            = each.value.name
  notes           = each.value.notes
  organization_id = each.value.organization_id
  product_types   = each.value.product_types
  tags            = each.value.tags
  time_zone       = each.value.time_zone
}

# locals {
#   admins = flatten([
#     for org in try(local.meraki.organizations, []) : [
#       for admin in try(org.administrators, []) : {
#         key                   = format("%s/%s", org.name, admin.name)
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
#   ])
# }

# resource "meraki_organizations_admins" "organizations_admins" {
#   for_each = { for admin in local.admins : admin.key => admin }

#   organization_id       = each.value.organization_id
#   name                  = each.value.name
#   email                 = each.value.email
#   authentication_method = each.value.authentication_method
#   org_access            = each.value.org_access
#   networks              = each.value.networks
#   tags                  = each.value.tags
# }
