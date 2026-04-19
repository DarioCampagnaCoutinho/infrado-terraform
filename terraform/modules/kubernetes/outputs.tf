output "cluster_id" {
  description = "ID of the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.this.id
}

output "cluster_name" {
  description = "Name of the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.this.name
}

output "endpoint" {
  description = "API server endpoint of the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.this.endpoint
}

output "kube_config" {
  description = "Kubeconfig for accessing the cluster (raw YAML)"
  value       = digitalocean_kubernetes_cluster.this.kube_config[0].raw_config
  sensitive   = true
}

output "cluster_urn" {
  description = "URN of the cluster, usable with other DigitalOcean resources (e.g. firewall, database trusted sources)"
  value       = digitalocean_kubernetes_cluster.this.urn
}
