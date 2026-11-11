output "vpc_id" {
  description = "UUID da VPC"
  value       = module.vpc.id
}

output "droplet_ipv4" {
  description = "IP público do Droplet"
  value       = module.droplet.ipv4_address
}

output "droplet_private_ipv4" {
  description = "IP privado do Droplet na VPC"
  value       = module.droplet.ipv4_address_private
}

output "database_host" {
  description = "Host público do PostgreSQL"
  value       = module.database.host
}

output "database_private_host" {
  description = "Host privado do PostgreSQL (acessível dentro da VPC)"
  value       = module.database.private_host
}

output "database_port" {
  description = "Porta do PostgreSQL"
  value       = module.database.port
}

output "kubernetes_endpoint" {
  description = "Endpoint da API do Kubernetes"
  value       = module.kubernetes.endpoint
}

output "kube_config" {
  description = "Kubeconfig do cluster (terraform output -raw kube_config)"
  value       = module.kubernetes.kube_config
  sensitive   = true
}
