terraform {
  required_version = ">= 0.14"

  required_providers {
    linode = {
      source  = "registry.terraform.io/linode/linode"
      version = "2.12.0"
    }
  }
}
