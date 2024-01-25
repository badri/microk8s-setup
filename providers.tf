provider "dnsimple" {
  alias   = "dnsimple"
  token   = var.dnsimple_token
  account = var.dnsimple_account
}

provider "godaddy" {
  alias  = "godaddy"
  key    = var.godaddy_api_key
  secret = var.godaddy_secret
}

provider "digitalocean" {
  token = var.do_token
  alias = "digitalocean"
}

provider "linode" {
  token = var.linode_token
  alias = "linode"
}

provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  alias      = "aws"
}
