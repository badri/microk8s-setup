provider "digitalocean" {
  token = var.do_token
  alias = "digitalocean"
}

provider "linode" {
  token = var.linode_token
  alias = "linode"
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  alias      = "aws"
}
