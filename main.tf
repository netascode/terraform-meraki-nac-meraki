locals {
  meraki = try(local.model.meraki, {})
}
