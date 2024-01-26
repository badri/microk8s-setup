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
  owners = ["amazon"]
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

resource "aws_security_group" "allow_ssh" {
  name        = "security-group-${var.ssh_key_prefix}"
  description = "Allow SSH inbound traffic"

  # Existing rule for SSH (port 22)
  ingress {
    description      = "SSH from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # Rule for Kubernetes API server (port 16443)
  ingress {
    description      = "Kubernetes API server"
    from_port        = 16443
    to_port          = 16443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # Rule for MicroK8s node join port (port 25000)
  ingress {
    description      = "MicroK8s node join port"
    from_port        = 25000
    to_port          = 25000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # Rule for HTTP (port 80)
  ingress {
    description      = "HTTP traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # Rule for HTTPS (port 443)
  ingress {
    description      = "HTTPS traffic"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # Rule for kubelet API (port 10250) from instances within the same security group
  ingress {
    description              = "kubelet API"
    from_port                = 10250
    to_port                  = 10250
    protocol                 = "tcp"
    source_security_group_id = aws_security_group.allow_ssh.id  # Referencing the same security group
  }

   # Outbound rule: Allow all outbound traffic for internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
    From = "ShapeBlock"
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "terraform-ssh-key-${var.ssh_key_prefix}"
  public_key = var.ssh_key
}

resource "aws_instance" "vm" {
  for_each = {
    for vm in local.vms : vm.name => vm
  }

  ami             = data.aws_ami.ubuntu.id
  instance_type   = each.value.type
  key_name        = aws_key_pair.ssh_key.key_name
  security_groups = [aws_security_group.allow_ssh.name]

  tags = {
    Name        = each.value.name
    shapeblock  = "shapeblock"
    NodeGroup   = each.value.name
    NodeGroupId = each.value.id
  }
}

