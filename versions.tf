terraform {
  required_version = ">= 1.9.0"

  required_providers {
    meraki = {
      source  = "CiscoDevNet/meraki"
      version = ">= 1.8.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.0.0"
    }
  }
}
