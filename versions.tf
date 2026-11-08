terraform {
  required_version = ">= 1.9.0"

  required_providers {
    meraki = {
      source  = "CiscoDevNet/meraki"
      version = ">= 1.14.1, < 2.0.0"
    }
    utils = {
      source  = "netascode/utils"
      version = ">= 2.2.0, < 3.0.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.0, < 3.0.0"
    }
  }
}
