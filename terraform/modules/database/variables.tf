variable "cluster_name" {
  type        = string
  description = "Nome do cluster de banco de dados"
}

variable "db_name" {
  type        = string
  description = "Nome do banco de dados"
}

variable "engine" {
  type        = string
  description = "Engine do banco (ex: pg, mysql)"
  default     = "pg"
}

variable "engine_version" {
  type        = string
  description = "Versão do engine"
}

variable "size" {
  type        = string
  description = "Tamanho do cluster (ex: db-s-2vcpu-4gb)"
}

variable "region" {
  type        = string
  description = "Região do cluster"
}

variable "node_count" {
  type        = number
  description = "Número de nós do cluster"
  default     = 1
}

variable "private_network_uuid" {
  type        = string
  description = "UUID da VPC do cluster. null usa a VPC default da região. ATENÇÃO: alterar em cluster existente força recriação."
  default     = null
}

variable "trusted_sources" {
  type = list(object({
    type  = string
    value = string
  }))
  description = "Origens liberadas no firewall do banco (type: ip_addr, droplet, k8s, tag, app). Lista vazia = sem firewall (aberto)."
  default     = []
}
