resource "digitalocean_ssh_key" "this" {
  name       = var.key_name
  public_key = var.public_key
}
