output "cluster_id" {
  value = digitalocean_database_cluster.this.id
}

output "host" {
  value = digitalocean_database_cluster.this.host
}

output "port" {
  value = digitalocean_database_cluster.this.port
}

output "db_name" {
  value = digitalocean_database_db.this.name
}

output "private_host" {
  value = digitalocean_database_cluster.this.private_host
}
