resource "digitalocean_droplet" "this" {
  name     = var.name
  size     = var.size
  image    = var.image
  region   = var.region
  ssh_keys = var.ssh_key_ids

  lifecycle {
    ignore_changes = [ssh_keys]
  }
}
