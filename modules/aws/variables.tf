variable "ssh_key_prefix" {
  description = "Prefix for the SSH key"
  type        = string
}

variable "ssh_key" {
  description = "SSH public key as a string"
  type        = string
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
