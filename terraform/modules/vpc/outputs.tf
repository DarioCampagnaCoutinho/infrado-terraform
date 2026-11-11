output "id" {
  description = "UUID da VPC"
  value       = digitalocean_vpc.this.id
}

output "urn" {
  description = "URN da VPC"
  value       = digitalocean_vpc.this.urn
}

output "ip_range" {
  description = "Bloco CIDR da VPC"
  value       = digitalocean_vpc.this.ip_range
}
