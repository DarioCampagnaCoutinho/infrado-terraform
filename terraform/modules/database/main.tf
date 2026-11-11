resource "digitalocean_database_cluster" "this" {
  name       = var.cluster_name
  engine     = var.engine
  version    = var.engine_version
  size       = var.size
  region     = var.region
  node_count = var.node_count

  private_network_uuid = var.private_network_uuid
}

resource "digitalocean_database_db" "this" {
  cluster_id = digitalocean_database_cluster.this.id
  name       = var.db_name
}

resource "digitalocean_database_firewall" "this" {
  count = length(var.trusted_sources) > 0 ? 1 : 0

  cluster_id = digitalocean_database_cluster.this.id

  dynamic "rule" {
    for_each = var.trusted_sources
    content {
      type  = rule.value.type
      value = rule.value.value
    }
  }
}
