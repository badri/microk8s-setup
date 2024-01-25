terraform {
  required_version = ">= 0.14"

  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "5.33.0"
    }
  }
}
