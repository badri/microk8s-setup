resource "godaddy_domain_record" "ingress" {
  domain = var.tld
  record {
    name = var.dns
    type = "A"
    data = var.ha_ip
    ttl  = 3600
  }
}

resource "godaddy_domain_record" "cname" {
  domain = var.tld
  record {
    name = "*.${var.dns}"
    type = "CNAME"
    data = "${var.dns}.${var.tld}"
    ttl  = 3600
  }
}
