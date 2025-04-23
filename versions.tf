terraform {
  required_version = ">= 1.5.7"

  required_providers {
    meraki = {
      source  = "CiscoDevNet/meraki"
      version = ">= 0.1.12"
    }

    utils = {
      source  = "netascode/utils"
      version = ">= 0.2.6"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.2"
    }
  }
}
