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
