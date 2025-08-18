terraform {
  required_version = ">= 1.9.0"

  required_providers {
    meraki = {
      source  = "CiscoDevNet/meraki"
      version = ">= 1.5.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9.0"
    }
  }
}
