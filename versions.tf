terraform {
  required_version = ">= 1.9.0"

  required_providers {
    meraki = {
      source  = "CiscoDevNet/meraki"
      version = ">= 0.1.12"
    }
  }
}
