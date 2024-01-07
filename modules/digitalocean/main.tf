locals {
  vms = flatten([
    for node_group in var.node_group_config : [
      for i in range(node_group.count) : {
        name = "${node_group.name}"
        size = node_group.size
        id   = node_group.id
      }
    ]
  ])
}

resource "digitalocean_ssh_key" "ssh_key" {
  name       = "terraform-ssh-key-${var.ssh_key_prefix}"
  public_key = var.ssh_key
}

// TODO: Add tags to all resources
resource "digitalocean_droplet" "vm" {
  for_each = {
    for vm in local.vms : vm.name => vm
  }
  name       = each.value.name
  region     = var.region
  size       = each.value.size
  image      = var.image
  ssh_keys   = [digitalocean_ssh_key.ssh_key.id]
  tags       = ["shapeblock", each.value.name, each.value.id]
  monitoring = true # Enable monitoring if desired
}

data "digitalocean_droplets" "vms" {
  for_each = {
    for node_group in var.node_group_config : node_group.name => node_group
  }
  filter {
    key    = "tags"
    values = ["shapeblock", each.key]
    all    = true
  }
  depends_on = [digitalocean_droplet.vm]
}
