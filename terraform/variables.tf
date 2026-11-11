variable "do_token" {
  type        = string
  description = "Token da API da DigitalOcean"
  sensitive   = true
}

variable "ssh_public_key" {
  type        = string
  description = "Chave publica SSH registrada na DigitalOcean"
  sensitive   = true
}

variable "project_name" {
  type        = string
  description = "Prefixo usado nos nomes dos recursos"
  default     = "api-payment"
}

variable "region" {
  type        = string
  description = "Região da DigitalOcean para todos os recursos"
  default     = "nyc3"
}

variable "vpc_ip_range" {
  type        = string
  description = "CIDR da VPC. Não pode sobrepor outras VPCs da conta nem 10.244.0.0/16 e 10.245.0.0/16 (DOKS)."
  default     = "10.10.0.0/20"
}

variable "ssh_key_name" {
  type        = string
  description = "Nome da SSH key na DigitalOcean"
  default     = "gitlab-deploy-key"
}

variable "ssh_allowed_cidrs" {
  type        = list(string)
  description = "CIDRs que podem acessar o Droplet via SSH (porta 22). Restrinja ao IP da sua rede/runner."
  default     = ["0.0.0.0/0", "::/0"]
}

variable "droplet_public_tcp_ports" {
  type        = list(string)
  description = "Portas TCP do Droplet abertas para a internet"
  default     = ["80", "443"]
}

variable "droplet_size" {
  type        = string
  description = "Tamanho do Droplet"
  default     = "s-1vcpu-2gb"
}

variable "droplet_image" {
  type        = string
  description = "Imagem do Droplet"
  default     = "ubuntu-22-04-x64"
}

variable "db_engine_version" {
  type        = string
  description = "Versão do PostgreSQL"
  default     = "16"
}

variable "db_size" {
  type        = string
  description = "Tamanho do cluster PostgreSQL"
  default     = "db-s-1vcpu-2gb"
}

variable "db_trusted_ips" {
  type        = list(string)
  description = "IPs/CIDRs extras liberados no firewall do banco (ex: IP de quem administra)"
  default     = []
}

variable "k8s_node_size" {
  type        = string
  description = "Tamanho dos nós do Kubernetes"
  default     = "s-1vcpu-2gb"
}

variable "k8s_node_count" {
  type        = number
  description = "Quantidade de nós do Kubernetes"
  default     = 2
}
