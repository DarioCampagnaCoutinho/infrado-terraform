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
