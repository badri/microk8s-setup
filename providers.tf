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
