variable "name" {
  type        = string
  description = "Nome da VPC (único na conta)"
}

variable "region" {
  type        = string
  description = "Região da VPC (ex: nyc3). Os recursos ligados a ela precisam estar na mesma região."
}

variable "ip_range" {
  type        = string
  description = "Bloco CIDR privado da VPC (ex: 10.10.0.0/20). Não pode sobrepor outras VPCs da conta nem as redes do DOKS (10.244.0.0/16 e 10.245.0.0/16)."

  validation {
    condition     = can(cidrhost(var.ip_range, 0))
    error_message = "ip_range precisa ser um CIDR válido, ex: 10.10.0.0/20."
  }

  validation {
    condition     = tonumber(split("/", var.ip_range)[1]) >= 16 && tonumber(split("/", var.ip_range)[1]) <= 28
    error_message = "A DigitalOcean aceita prefixos entre /16 e /28."
  }
}

variable "description" {
  type        = string
  description = "Descrição da VPC"
  default     = null
}
