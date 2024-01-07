terraform {
  required_version = ">= 0.14"

  required_providers {
    digitalocean = {
      source  = "registry.terraform.io/digitalocean/digitalocean"
      version = "2.34.0"
    }
  }
}
