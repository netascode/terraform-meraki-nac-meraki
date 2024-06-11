
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
# output "domains" {
#   value = local.meraki.domains
# }
output "test" {
  value = local.model_strings
}