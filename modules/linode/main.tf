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

resource "linode_sshkey" "ssh_key" {
  label   = "terraform-ssh-key-${var.ssh_key_prefix}"
  ssh_key = chomp(var.ssh_key)
}

resource "linode_instance" "vm" {
  for_each = {
    for vm in local.vms : vm.name => vm
  }
  label           = each.value.name
  region          = var.region
  type            = each.value.size
  image           = var.image
  authorized_keys = [linode_sshkey.ssh_key.ssh_key]
  tags            = ["shapeblock", each.value.name, each.value.id]
}

data "linode_instances" "vms" {
  for_each = {
    for node_group in var.node_group_config : node_group.name => node_group
  }
  filter {
    name   = "tags"
    values = ["shapeblock", each.key]
  }
  depends_on = [linode_instance.vm]
  order_by   = "id"
}
