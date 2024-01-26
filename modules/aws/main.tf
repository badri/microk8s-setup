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
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Rule for Kubernetes API server (port 16443)
  ingress {
    description = "Kubernetes API server"
    from_port   = 16443
    to_port     = 16443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Rule for MicroK8s node join port (port 25000)
  ingress {
    description = "MicroK8s node join port"
    from_port   = 25000
    to_port     = 25000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Rule for HTTP (port 80)
  ingress {
    description = "HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Rule for HTTPS (port 443)
  ingress {
    description = "HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rule: Allow all outbound traffic for internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
    From = "ShapeBlock"
  }
}

# Rule for kubelet API (port 10250) from instances within the same security group
resource "aws_security_group_rule" "kubelet_api" {
  description       = "kubelet API"
  type              = "ingress"
  from_port         = 10250
  to_port           = 10250
  protocol          = "tcp"
  security_group_id = aws_security_group.allow_ssh.id
  self              = true
}

# Ingress rule for kubelet read-only port (TCP 10255)
resource "aws_security_group_rule" "kubelet_readonly" {
  description       = "kubelet read-only port"
  type              = "ingress"
  from_port         = 10255
  to_port           = 10255
  protocol          = "tcp"
  security_group_id = aws_security_group.allow_ssh.id
  self              = true
}

# Ingress rule for etcd (TCP 12379)
resource "aws_security_group_rule" "etcd" {
  description       = "etcd"
  type              = "ingress"
  from_port         = 12379
  to_port           = 12379
  protocol          = "tcp"
  security_group_id = aws_security_group.allow_ssh.id
  self              = true
}

# Ingress rule for kube-controller (TCP 10257)
resource "aws_security_group_rule" "kube_controller" {
  description       = "kube-controller"
  type              = "ingress"
  from_port         = 10257
  to_port           = 10257
  protocol          = "tcp"
  security_group_id = aws_security_group.allow_ssh.id
  self              = true
}

# Ingress rule for kube-scheduler (TCP 10259)
resource "aws_security_group_rule" "kube_scheduler" {
  description       = "kube-scheduler HTTPS with auth"
  type              = "ingress"
  from_port         = 10259
  to_port           = 10259
  protocol          = "tcp"
  security_group_id = aws_security_group.allow_ssh.id
  self              = true
}

# Ingress rule for dqlite (TCP 19001)
resource "aws_security_group_rule" "dqlite" {
  description       = "dqlite SSL encrypted"
  type              = "ingress"
  from_port         = 19001
  to_port           = 19001
  protocol          = "tcp"
  security_group_id = aws_security_group.allow_ssh.id
  self              = true
}

# Ingress rule for Calico networking (UDP port 4789)
resource "aws_security_group_rule" "calico" {
  description       = "Calico networking (VXLAN)"
  type              = "ingress"
  from_port         = 4789
  to_port           = 4789
  protocol          = "udp"
  security_group_id = aws_security_group.allow_ssh.id
  self              = true
}

# Ingress rule for kubelet localhost healthz endpoint (TCP 10248)
resource "aws_security_group_rule" "healthz" {
  description       = "kubelet healthz endpoint"
  type              = "ingress"
  from_port         = 10248
  to_port           = 10248
  protocol          = "tcp"
  security_group_id = aws_security_group.allow_ssh.id
  self              = true
}

# Ingress rule for kube-proxy metrics server (TCP 10249)
resource "aws_security_group_rule" "kubeproxy_metrics" {
  description       = "kube-proxy metrics server"
  type              = "ingress"
  from_port         = 10249
  to_port           = 10249
  protocol          = "tcp"
  security_group_id = aws_security_group.allow_ssh.id
  self              = true
}

# Ingress rule for kube-scheduler HTTP (TCP 10251)
resource "aws_security_group_rule" "kube_scheduler_http" {
  description       = "kube-scheduler HTTP"
  type              = "ingress"
  from_port         = 10251
  to_port           = 10251
  protocol          = "tcp"
  security_group_id = aws_security_group.allow_ssh.id
  self              = true
}

# Ingress rule for kube-controller HTTP (TCP 10252)
resource "aws_security_group_rule" "kube_controller_http" {
  description       = "kube-controller HTTP"
  type              = "ingress"
  from_port         = 10252
  to_port           = 10252
  protocol          = "tcp"
  security_group_id = aws_security_group.allow_ssh.id
  self              = true
}

# Ingress rule for kube-proxy health check server (TCP 10256)
resource "aws_security_group_rule" "healthcheck" {
  description       = "kube-proxy health check"
  type              = "ingress"
  from_port         = 10256
  to_port           = 10256
  protocol          = "tcp"
  security_group_id = aws_security_group.allow_ssh.id
  self              = true
}

# Ingress rule for etcd peer connections (TCP 2380)
resource "aws_security_group_rule" "etcd_peer" {
  description       = "etcd peer connections"
  type              = "ingress"
  from_port         = 2380
  to_port           = 2380
  protocol          = "tcp"
  security_group_id = aws_security_group.allow_ssh.id
  self              = true
}

# Ingress rule for containerd metrics port (TCP 1338)
resource "aws_security_group_rule" "containerd" {
  description       = "containerd metrics port"
  type              = "ingress"
  from_port         = 1338
  to_port           = 1338
  protocol          = "tcp"
  security_group_id = aws_security_group.allow_ssh.id
  self              = true
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

  root_block_device {
    volume_type           = "gp3" # General Purpose SSD (gp3)
    volume_size           = 80    # 80 GiB
    delete_on_termination = true
  }

  tags = {
    Name        = each.value.name
    shapeblock  = "shapeblock"
    NodeGroup   = each.value.name
    NodeGroupId = each.value.id
  }
}

