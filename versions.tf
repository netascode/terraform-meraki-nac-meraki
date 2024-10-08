terraform {
  required_version = ">= 0.1.0"

  required_providers {
    meraki = {
        source  = "CiscoDevNet/meraki"
        version = "0.1.2"
    }

    utils = {
      source  = "netascode/utils"
      version = ">= 0.2.5"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.1"
    }
  }
}
provider "meraki" {
  api_key = var.api_key
}
