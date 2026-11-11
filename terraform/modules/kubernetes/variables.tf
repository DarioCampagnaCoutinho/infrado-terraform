variable "cluster_name" {
  type        = string
  description = "Name of the Kubernetes cluster"
}

variable "region" {
  type        = string
  description = "DigitalOcean region where the cluster will be created"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version (e.g. 1.32.2-do.0). Leave empty to use the latest available."
  default     = ""
}

variable "node_pool_name" {
  type        = string
  description = "Name of the default node pool"
  default     = "default-pool"
}

variable "node_size" {
  type        = string
  description = "Machine size for the node pool (e.g. s-2vcpu-4gb)"
  default     = "s-2vcpu-4gb"
}

variable "node_count" {
  type        = number
  description = "Number of nodes in the default node pool (used when auto_scale is false)"
  default     = 2
}

variable "auto_scale" {
  type        = bool
  description = "Enable autoscaling for the default node pool"
  default     = false
}

variable "min_nodes" {
  type        = number
  description = "Minimum number of nodes when autoscaling is enabled"
  default     = 1
}

variable "max_nodes" {
  type        = number
  description = "Maximum number of nodes when autoscaling is enabled"
  default     = 3
}

variable "tags" {
  type        = list(string)
  description = "List of tags to apply to the cluster"
  default     = []
}

variable "vpc_uuid" {
  type        = string
  description = "UUID da VPC. null usa a VPC default da região. ATENÇÃO: alterar em recurso existente força recriação."
  default     = null
}
