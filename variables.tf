variable "region" {
  type        = string
  description = "Cloud provider region"
}

variable "dns" {
  type = string
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

variable "tld" {
  type    = string
  default = "shapeblockapp.com"
}

variable "sb_url" {
  type = string
}

variable "cluster_uuid" {
  type = string
}

variable "email" {
  type = string
}

variable "cloud_provider" {
  type = string
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

variable "aws_access_key" {
  description = "AWS Access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret key"
  type        = string
  sensitive   = true
}

variable "dns_provider" {
  description = "DNS provider to use. Can be 'godaddy' or 'dnsimple'."
  type        = string
}

# Variables for GoDaddy provider configuration
variable "godaddy_api_key" {
  description = "API key for GoDaddy provider"
  type        = string
  sensitive   = true
}

variable "godaddy_secret" {
  description = "Secret key for GoDaddy provider"
  type        = string
  sensitive   = true
}

# Variable for DNSimple provider configuration
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
