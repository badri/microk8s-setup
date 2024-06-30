terraform {
  required_version = ">= 0.14"

  required_providers {
    godaddy = {
      source  = "registry.terraform.io/n3integration/godaddy"
      version = "~> 1.0"
    }
    dnsimple = {
      source  = "registry.terraform.io/dnsimple/dnsimple"
      version = "1.3.1"
    }
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
