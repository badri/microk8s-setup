variable "region" {
  type        = string
  description = "Cloud provider region"
}

variable "image" {
  type        = string
  description = "Base image for the VMs"
}

variable "node_group_config" {
  type = list(object({
    name  = string
    size  = string
    count = number
    id    = string
  }))
  description = "Node group configuration for VM deployment"
}

variable "cluster_uuid" {
  type = string
}

variable "cloud_provider" {
  type = string

  validation {
    condition     = contains(["linode", "digitalocean"], var.cloud_provider)
    error_message = "Must be either \"linode\" or \"digitalocean\"."
  }
}

variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "linode_token" {
  description = "Linode API token"
  type        = string
  sensitive   = true
}

variable "dns" {
  type = string
}

variable "tld" {
  type    = string
  default = "shapeblockapp.com"
}

variable "dnsimple_token" {
  description = "Token for DNSimple provider"
  type        = string
  sensitive   = true
}

variable "dnsimple_account" {
  description = "DNSimple account"
  type        = string
  sensitive   = true
}
