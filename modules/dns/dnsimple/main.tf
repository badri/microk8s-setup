resource "dnsimple_zone_record" "ingress" {
  zone_name = var.tld
  name      = var.dns
  value     = var.ha_ip
  type      = "A"
  ttl       = 3600
}


resource "dnsimple_zone_record" "cname" {
  zone_name = var.tld
  name      = "*.${var.dns}"
  value     = "${var.dns}.${var.tld}"
  type      = "CNAME"
  ttl       = 3600
}
