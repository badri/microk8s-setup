output "vm_info" {
  value = {
    for vm in linode_instance.vm :
    vm.label => vm.ip_address
  }
}

output "ha_host" {
  value = lookup(data.linode_instances.vms, var.node_group_config.0.name).instances.0.label
}

output "ha_ip" {
  value = lookup(data.linode_instances.vms, var.node_group_config.0.name).instances.0.ip_address
}

output "root_pass" {
  value = random_password.root_password.result
}
