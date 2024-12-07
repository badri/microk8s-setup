terraform {
  required_version = ">= 0.14"

  required_providers {
    digitalocean = {
      source  = "registry.terraform.io/digitalocean/digitalocean"
      version = "2.34.0"
    }
    linode = {
      source  = "registry.terraform.io/linode/linode"
      version = "2.12.0"
    }
  }

  backend "pg" {
  }
}
