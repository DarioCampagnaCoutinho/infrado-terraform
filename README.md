# infrado-terraform

Infraestrutura como código em Terraform para provisionamento de recursos na DigitalOcean. O projeto atualmente cria uma chave SSH, uma VPC privada, um Droplet com Cloud Firewall, um cluster PostgreSQL gerenciado com firewall e um cluster Kubernetes, com `tfstate` remoto armazenado em DigitalOcean Spaces via backend compatível com S3.

## Visão geral

O código principal está em [terraform/main.tf](terraform/main.tf) e orquestra cinco módulos locais:

- `modules/vpc`: cria a VPC privada onde Droplet, banco e Kubernetes se comunicam.
- `modules/ssh`: registra uma chave pública SSH na conta da DigitalOcean.
- `modules/droplet`: cria um Droplet Ubuntu e o Cloud Firewall dele (SSH, portas públicas e tráfego interno da VPC).
- `modules/database`: cria um cluster gerenciado de PostgreSQL e um database dentro do cluster, com firewall liberando apenas origens confiáveis.
- `modules/kubernetes`: cria um cluster Kubernetes com node pool padrão.

## Recursos provisionados

Pelo estado atual da configuração, o projeto provisiona:

- 1 VPC chamada `api-payment-vpc` (`10.10.0.0/20`)
- 1 chave SSH chamada `gitlab-deploy-key`
- 1 Droplet chamado `api-payment-backend` + firewall `api-payment-backend-fw`
- 1 cluster PostgreSQL chamado `postgres-api-payment`
- 1 database chamado `api-payment`
- 1 firewall do banco liberando o cluster Kubernetes, o Droplet e `db_trusted_ips`
- 1 cluster Kubernetes chamado `api-payment-k8s`
- 1 node pool chamado `api-payment-pool` com 2 nós

Todos os recursos ficam na região `nyc3` (variável `region`) e dentro da mesma VPC.

## Estrutura do repositório

```text
.
|-- .github/
|   `-- workflows/
|       `-- infra.yml
|-- terraform/
|   |-- main.tf
|   |-- variables.tf
|   |-- outputs.tf
|   `-- modules/
|       |-- vpc/
|       |-- ssh/
|       |-- droplet/
|       |-- database/
|       `-- kubernetes/
`-- README.md
```

## Pré-requisitos

- Terraform `>= 1.6` (o CI usa `1.16.4`)
- Conta na DigitalOcean
- Token da API da DigitalOcean com permissão para criar recursos
- Bucket no DigitalOcean Spaces para armazenar o estado remoto
- Credenciais do Spaces exportadas no ambiente para o backend S3 compatível

## Variáveis de entrada

As variáveis declaradas em [terraform/variables.tf](terraform/variables.tf) são:

Obrigatórias:

- `do_token`: token da API da DigitalOcean
- `ssh_public_key`: chave pública SSH que será registrada na DigitalOcean

Opcionais (com valor padrão): `project_name`, `region`, `vpc_ip_range`, `ssh_key_name`, `ssh_allowed_cidrs`, `droplet_public_tcp_ports`, `droplet_size`, `droplet_image`, `db_engine_version`, `db_size`, `db_trusted_ips`, `k8s_node_size`, `k8s_node_count`.

Recomenda-se restringir `ssh_allowed_cidrs` (hoje liberado para qualquer IP) e usar `db_trusted_ips` para liberar o seu IP no banco, já que o firewall bloqueia qualquer origem fora do Droplet e do Kubernetes.

Exemplo em PowerShell:

```powershell
$env:TF_VAR_do_token = "seu_token_do_digitalocean"
$env:TF_VAR_ssh_public_key = "ssh-rsa AAAA..."

# Credenciais do Spaces para o backend do state
$env:AWS_ACCESS_KEY_ID = "sua_access_key"
$env:AWS_SECRET_ACCESS_KEY = "sua_secret_key"
```

## Backend remoto

O backend Terraform está configurado para usar:

- `bucket`: `api-payment-tfstate`
- `key`: `terraform/state`
- `endpoints.s3`: `https://nyc3.digitaloceanspaces.com`

Como o backend é do tipo `s3`, o Terraform depende das variáveis `AWS_ACCESS_KEY_ID` e `AWS_SECRET_ACCESS_KEY` no ambiente para conseguir executar `terraform init`.

## Como executar localmente

No diretório [terraform](terraform):

```powershell
terraform init
terraform validate
terraform plan
terraform apply
```

Para destruir a infraestrutura:

```powershell
terraform destroy
```

## CI/CD

O workflow [infra.yml](.github/workflows/infra.yml) usa Terraform `1.16.4` fixo e possui dois jobs:

- `terraform-plan`: roda em pull requests e em `push` para `main`. Executa `fmt -check`, `init`, `validate` e `plan -out=tfplan`; no push, publica o plano como artefato.
- `terraform-apply`: roda apenas em `push` para `main` e aplica exatamente o `tfplan` gerado no job anterior.

Para exigir aprovação manual antes do apply, configure **Required reviewers** no environment `main` em *Settings → Environments*.

Secrets esperados no GitHub Actions:

- `DO_TOKEN`
- `DO_SPACES_ACCESS_KEY`
- `DO_SPACES_SECRET_KEY`
- `SSH_PUBLIC_KEY`

## Observações sobre a configuração atual

- A chave pública SSH não fica mais hardcoded no código. Ela deve ser injetada por variável de ambiente (`TF_VAR_ssh_public_key`) ou por secret no CI.
- O `README` documenta o comportamento atual do repositório; ele não assume módulos, ambientes ou workspaces que não existam no código.
- [terraform/outputs.tf](terraform/outputs.tf) expõe IPs do Droplet, hosts do banco, endpoint do Kubernetes e o kubeconfig (`terraform output -raw kube_config`).
- O arquivo `.terraform.lock.hcl` é versionado e contém hashes para Linux, macOS e Windows.

## Próximos passos recomendados

- Separar ambientes como `dev`, `staging` e `prod` se esse repositório evoluir além de um único stack
