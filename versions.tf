terraform {
  required_version = ">= 1.3.0"

  required_providers {
    meraki = {
      source  = "cisco-open/meraki"
      version = "0.2.3-alpha"
    }
    utils = {
      source  = "netascode/utils"
      version = ">= 0.2.5"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.3.0"
    }
  }
}
