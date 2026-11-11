resource "digitalocean_droplet" "this" {
  name     = var.name
  size     = var.size
  image    = var.image
  region   = var.region
  ssh_keys = var.ssh_key_ids
  vpc_uuid = var.vpc_uuid

  lifecycle {
    ignore_changes = [ssh_keys]
  }
}

resource "digitalocean_firewall" "this" {
  count = var.firewall_enabled ? 1 : 0

  name        = "${var.name}-fw"
  droplet_ids = [digitalocean_droplet.this.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = var.ssh_allowed_cidrs
  }

  dynamic "inbound_rule" {
    for_each = var.public_tcp_ports
    content {
      protocol         = "tcp"
      port_range       = inbound_rule.value
      source_addresses = ["0.0.0.0/0", "::/0"]
    }
  }

  dynamic "inbound_rule" {
    for_each = var.vpc_ip_range == null ? [] : ["tcp", "udp"]
    content {
      protocol         = inbound_rule.value
      port_range       = "1-65535"
      source_addresses = [var.vpc_ip_range]
    }
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
