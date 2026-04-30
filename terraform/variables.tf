variable "do_token" {
  type        = string
  description = "Token DO"
}

variable "do_spaces_secret_key" {
  type        = string
  description = "Secret Space"
}

variable "do_spaces_access_key" {
  type        = string
  description = "Access Space"
}

variable "ssh_public_key" {
  type        = string
  description = "Chave publica SSH registrada na DigitalOcean"
  sensitive   = true
}
