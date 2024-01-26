data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = [ "amazon" ]
}

locals {
  vms = flatten([
    for node_group in var.node_group_config : [
      for i in range(node_group.count) : {
        name = "${node_group.name}"
        type = node_group.size
        id   = node_group.id
      }
    ]
  ])
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "terraform-ssh-key-${var.ssh_key_prefix}"
  public_key = var.ssh_key
}

resource "aws_instance" "vm" {
  for_each = {
    for vm in local.vms : vm.name => vm
  }

  ami           = data.aws_ami.ubuntu.id
  instance_type = each.value.type
  key_name      = aws_key_pair.ssh_key.key_name

  tags = {
    Name        = each.value.name
    shapeblock  = "shapeblock"
    NodeGroup   = each.value.name
    NodeGroupId = each.value.id
  }
}

