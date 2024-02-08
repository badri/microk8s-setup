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
resource "random_password" "root_password" {
  length  = 30
  upper   = false
  special = false
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
  tags            = ["shapeblock", var.cluster_uuid]
  root_pass       = random_password.root_password.result
}

data "linode_instances" "vms" {
  filter {
    name   = "tags"
    values = ["shapeblock", var.cluster_uuid]
  }
  depends_on = [linode_instance.vm]
  order_by   = "id"
}
