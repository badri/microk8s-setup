provider "digitalocean" {
  token = var.do_token
  alias = "digitalocean"
}

provider "linode" {
  token = var.linode_token
  alias = "linode"
}
