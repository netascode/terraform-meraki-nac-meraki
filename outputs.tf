
output "default_values" {
  description = "All default values."
  value       = local.defaults
}

output "model" {
  description = "Full model."
  value       = local.model
}
# Output the organization map
output "organization_map" {
  value = local.organization_map
}
output "domains" {
  value = local.login_security
}
output "test" {
  value = local.model_strings
}
output "CX_DEBUG" {
  value = local.admins
}

output "marcin_debug" {
  value = local.marcin_debug
}
