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

resource "random_id" "ssh_key_id" {
  byte_length = 8
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
}

module "digitalocean_vms" {
  source            = "./modules/digitalocean"
  count             = var.cloud_provider == "digitalocean" ? 1 : 0
  ssh_key_prefix    = random_id.ssh_key_id.hex
  ssh_key           = tls_private_key.ssh_key.public_key_openssh
  region            = var.region
  node_group_config = var.node_group_config
  image             = var.image
  cluster_uuid      = var.cluster_uuid
  providers = {
    digitalocean = digitalocean.digitalocean
  }
}

module "linode_vms" {
  source            = "./modules/linode"
  count             = var.cloud_provider == "linode" ? 1 : 0
  ssh_key_prefix    = random_id.ssh_key_id.hex
  ssh_key           = tls_private_key.ssh_key.public_key_openssh
  region            = var.region
  node_group_config = var.node_group_config
  image             = var.image
  cluster_uuid      = var.cluster_uuid
  providers = {
    linode = linode.linode
  }
}

locals {
  selected_module = (var.cloud_provider == "digitalocean") ? module.digitalocean_vms[0] : (var.cloud_provider == "linode") ? module.linode_vms[0] : null
}


locals {
  node_list_json = jsonencode([
    for hostname, ip in local.selected_module.vm_info : {
      hostname = hostname
      ip       = ip
    }
  ])
}

# Save the JSON content to a file
resource "local_file" "node_list_file" {
  filename = "${path.module}/devices.json"
  content  = local.node_list_json
}

resource "local_file" "vms" {
  content  = jsonencode(local.selected_module.vm_info)
  filename = "${path.module}/vms"
}

locals {
  # Create Ansible inventory content in INI format
  ansible_inventory = join("\n", [
    "[all]",
    join("\n", [
      for node in jsondecode(local.node_list_json) :
      "${node.hostname} ansible_host=${node.ip}"
    ])
  ])
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/inventory"
  content  = local.ansible_inventory
}
