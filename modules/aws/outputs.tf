output "vm_info" {
  value = {
    for instance in aws_instance.vm :
    instance.tags["Name"] => instance.public_ip
  }
  description = "Information about each VM, including name, public IP, and private IP."
}

output "ha_host" {
  value       = aws_instance.vm[var.node_group_config[0].name].tags["Name"]
  description = "The name tag of the High Availability host"
}

output "ha_ip" {
  value       = aws_instance.vm[var.node_group_config[0].name].public_ip
  description = "The public IP address of the High Availability host"
}
