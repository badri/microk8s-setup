terraform {
  required_version = ">= 0.14"

  required_providers {
    dnsimple = {
      source  = "registry.terraform.io/dnsimple/dnsimple"
      version = "1.3.1"
    }
  }
}
