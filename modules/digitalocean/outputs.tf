output "vm_info" {
  value = {
    for vm in digitalocean_droplet.vm :
    vm.name => vm.ipv4_address
  }
}

output "ha_host" {
  value = lookup(data.digitalocean_droplets.vms, var.node_group_config.0.name).droplets.0.name
}

output "ha_ip" {
  value = lookup(data.digitalocean_droplets.vms, var.node_group_config.0.name).droplets.0.ipv4_address
}
