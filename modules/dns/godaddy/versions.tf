terraform {
  required_version = ">= 0.14"

  required_providers {
    godaddy = {
      source  = "registry.terraform.io/n3integration/godaddy"
      version = "~> 1.0"
    }
  }
}
