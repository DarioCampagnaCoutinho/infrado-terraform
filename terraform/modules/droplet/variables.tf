variable "name" {
  type        = string
  description = "Nome do Droplet"
}

variable "size" {
  type        = string
  description = "Tamanho do Droplet (ex: s-4vcpu-8gb)"
}

variable "image" {
  type        = string
  description = "Imagem do SO (ex: ubuntu-20-04-x64)"
}

variable "region" {
  type        = string
  description = "Região do Droplet (ex: nyc3)"
}

variable "ssh_key_ids" {
  type        = list(string)
  description = "Lista de IDs das SSH keys"
}

variable "vpc_uuid" {
  type        = string
  description = "UUID da VPC. null usa a VPC default da região. ATENÇÃO: alterar em recurso existente força recriação."
  default     = null
}

variable "firewall_enabled" {
  type        = bool
  description = "Cria um Cloud Firewall para o Droplet"
  default     = true
}

variable "ssh_allowed_cidrs" {
  type        = list(string)
  description = "CIDRs liberados na porta 22"
  default     = ["0.0.0.0/0", "::/0"]
}

variable "public_tcp_ports" {
  type        = list(string)
  description = "Portas/faixas TCP abertas para a internet (ex: 80, 443, 8000-8080)"
  default     = ["80", "443"]
}

variable "vpc_ip_range" {
  type        = string
  description = "CIDR da VPC; se informado, libera todo tráfego TCP/UDP vindo dela"
  default     = null
}
