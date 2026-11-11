terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  required_version = ">= 1.6"

  # Credenciais do Spaces via AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY
  backend "s3" {
    endpoints = {
      s3 = "https://nyc3.digitaloceanspaces.com"
    }
    bucket = "api-payment-tfstate"
    key    = "terraform/state"
    region = "us-east-1"

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
  }
}

provider "digitalocean" {
  token = var.do_token
}

module "vpc" {
  source      = "./modules/vpc"
  name        = "${var.project_name}-vpc"
  region      = var.region
  ip_range    = var.vpc_ip_range
  description = "Rede privada do ${var.project_name} (droplet, postgres e k8s)"
}

module "ssh" {
  source     = "./modules/ssh"
  key_name   = var.ssh_key_name
  public_key = var.ssh_public_key
}

# ATENÇÃO: ligar Droplet, Postgres e Kubernetes já existentes à VPC força
# DESTROY + CREATE desses recursos. Faça backup do banco antes do apply.
module "droplet" {
  source      = "./modules/droplet"
  name        = "${var.project_name}-backend"
  size        = var.droplet_size
  image       = var.droplet_image
  region      = var.region
  ssh_key_ids = [module.ssh.id]
  vpc_uuid    = module.vpc.id

  ssh_allowed_cidrs = var.ssh_allowed_cidrs
  public_tcp_ports  = var.droplet_public_tcp_ports
  vpc_ip_range      = var.vpc_ip_range
}

module "database" {
  source               = "./modules/database"
  cluster_name         = "postgres-${var.project_name}"
  db_name              = var.project_name
  engine_version       = var.db_engine_version
  size                 = var.db_size
  region               = var.region
  private_network_uuid = module.vpc.id

  trusted_sources = concat(
    [
      { type = "k8s", value = module.kubernetes.cluster_id },
      { type = "droplet", value = module.droplet.id },
    ],
    [for ip in var.db_trusted_ips : { type = "ip_addr", value = ip }],
  )
}

module "kubernetes" {
  source         = "./modules/kubernetes"
  cluster_name   = "${var.project_name}-k8s"
  region         = var.region
  vpc_uuid       = module.vpc.id
  node_pool_name = "${var.project_name}-pool"
  node_size      = var.k8s_node_size
  node_count     = var.k8s_node_count
  auto_scale     = false
  tags           = [var.project_name, "kubernetes"]
}
