data "digitalocean_kubernetes_versions" "available" {}

locals {
  k8s_version = var.kubernetes_version != "" ? var.kubernetes_version : data.digitalocean_kubernetes_versions.available.latest_version
}

resource "digitalocean_kubernetes_cluster" "this" {
  name     = var.cluster_name
  region   = var.region
  version  = local.k8s_version
  tags     = var.tags
  vpc_uuid = var.vpc_uuid

  node_pool {
    name       = var.node_pool_name
    size       = var.node_size
    node_count = var.auto_scale ? null : var.node_count
    auto_scale = var.auto_scale
    min_nodes  = var.auto_scale ? var.min_nodes : null
    max_nodes  = var.auto_scale ? var.max_nodes : null
    tags       = var.tags
  }
}
