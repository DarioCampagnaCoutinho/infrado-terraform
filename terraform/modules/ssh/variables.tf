variable "key_name" {
  type        = string
  description = "Nome da SSH key no DigitalOcean"
}

variable "public_key" {
  type        = string
  description = "Conteúdo da chave pública"
}
