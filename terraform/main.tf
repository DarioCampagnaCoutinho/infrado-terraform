terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  required_version = ">= 0.13"

  backend "s3" {
    endpoint                    = "https://nyc3.digitaloceanspaces.com"
    bucket                      = "api-payment-tfstate"
    key                         = "terraform/state"
    region                      = "us-east-1"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}

provider "digitalocean" {
  token = var.do_token
}

module "ssh" {
  source     = "./modules/ssh"
  key_name   = "gitlab-deploy-key"
  public_key = "ssh-rsa BBBBBBB6jkurjhghjyhbvff45tvccvbdtj,== email@email.com.br"
}

module "droplet" {
  source      = "./modules/droplet"
  name        = "api-payment-backend"
  size        = "s-1vcpu-2gb"
  image       = "ubuntu-22-04-x64"
  region      = "nyc3"
  ssh_key_ids = [module.ssh.id]
}

module "database" {
  source       = "./modules/database"
  cluster_name = "postgres-api-payment"
  db_name      = "api-payment"
  engine_version = "16"
  size         = "db-s-1vcpu-2gb"
  region       = "nyc3"
}

module "kubernetes" {
  source         = "./modules/kubernetes"
  cluster_name   = "api-payment-k8s"
  region         = "nyc3"
  node_pool_name = "api-payment-pool"
  node_size      = "s-1vcpu-2gb"
  node_count     = 2
  auto_scale     = false
  tags           = ["api-payment", "kubernetes"]
}
