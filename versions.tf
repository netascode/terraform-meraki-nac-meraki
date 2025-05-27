terraform {
  required_version = ">= 1.9.0"

  required_providers {
    meraki = {
      source  = "CiscoDevNet/meraki"
      version = ">= 1.2.1"
    }
  }
}
