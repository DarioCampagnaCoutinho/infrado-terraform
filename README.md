# infrado-terraform

Infraestrutura como código em Terraform para provisionamento de recursos na DigitalOcean. O projeto atualmente cria uma chave SSH, um Droplet, um cluster PostgreSQL gerenciado e um cluster Kubernetes, com `tfstate` remoto armazenado em DigitalOcean Spaces via backend compatível com S3.

## Visão geral

O código principal está em [terraform/main.tf](terraform/main.tf) e orquestra quatro módulos locais:

- `modules/ssh`: registra uma chave pública SSH na conta da DigitalOcean.
- `modules/droplet`: cria um Droplet Ubuntu.
- `modules/database`: cria um cluster gerenciado de PostgreSQL e um database dentro do cluster.
- `modules/kubernetes`: cria um cluster Kubernetes com node pool padrão.

## Recursos provisionados

Pelo estado atual da configuração, o projeto provisiona:

- 1 chave SSH chamada `gitlab-deploy-key`
- 1 Droplet chamado `api-payment-backend`
- 1 cluster PostgreSQL chamado `postgres-api-payment`
- 1 database chamado `api-payment`
- 1 cluster Kubernetes chamado `api-payment-k8s`
- 1 node pool chamado `api-payment-pool` com 2 nós

Todos os recursos estão configurados na região `nyc3`.

## Estrutura do repositório

```text
.
|-- .github/
|   `-- workflows/
|       `-- infra.yml
|-- terraform/
|   |-- main.tf
|   |-- variables.tf
|   `-- modules/
|       |-- ssh/
|       |-- droplet/
|       |-- database/
|       `-- kubernetes/
`-- README.md
```

## Pré-requisitos

- Terraform `>= 0.13`
- Conta na DigitalOcean
- Token da API da DigitalOcean com permissão para criar recursos
- Bucket no DigitalOcean Spaces para armazenar o estado remoto
- Credenciais do Spaces exportadas no ambiente para o backend S3 compatível

## Variáveis de entrada

As variáveis declaradas em [terraform/variables.tf](terraform/variables.tf) são:

- `do_token`: token da API da DigitalOcean
- `do_spaces_access_key`: access key do Spaces
- `do_spaces_secret_key`: secret key do Spaces
- `ssh_public_key`: chave pública SSH que será registrada na DigitalOcean

Exemplo em PowerShell:

```powershell
$env:TF_VAR_do_token = "seu_token_do_digitalocean"
$env:TF_VAR_do_spaces_access_key = "sua_access_key"
$env:TF_VAR_do_spaces_secret_key = "sua_secret_key"
$env:TF_VAR_ssh_public_key = "ssh-rsa AAAA..."

$env:AWS_ACCESS_KEY_ID = $env:TF_VAR_do_spaces_access_key
$env:AWS_SECRET_ACCESS_KEY = $env:TF_VAR_do_spaces_secret_key
```

## Backend remoto

O backend Terraform está configurado para usar:

- `bucket`: `api-payment-tfstate`
- `key`: `terraform/state`
- `endpoint`: `https://nyc3.digitaloceanspaces.com`

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

O workflow [infra.yml](.github/workflows/infra.yml) executa em `push` para a branch `main` e possui dois jobs:

- `terraform-plan`: faz checkout, prepara credenciais do Spaces, executa `terraform init`, `terraform validate` e `terraform plan`
- `terraform-apply`: depende do `plan`, reinicializa o Terraform e executa `terraform apply -auto-approve`

Secrets esperados no GitHub Actions:

- `DO_TOKEN`
- `DO_SPACES_ACCESS_KEY`
- `DO_SPACES_SECRET_KEY`
- `SSH_PUBLIC_KEY`

## Observações sobre a configuração atual

- A chave pública SSH não fica mais hardcoded no código. Ela deve ser injetada por variável de ambiente (`TF_VAR_ssh_public_key`) ou por secret no CI.
- O `README` documenta o comportamento atual do repositório; ele não assume módulos, ambientes ou workspaces que não existam no código.
- Os módulos possuem `outputs`, mas não há `outputs.tf` na raiz expondo esses valores para consumo direto após `apply`.

## Próximos passos recomendados

- Extrair valores fixos como nomes, região, tamanhos e chave SSH para variáveis
- Adicionar `outputs.tf` na raiz para expor IP do Droplet, endpoint do banco e kubeconfig do cluster
- Separar ambientes como `dev`, `staging` e `prod` se esse repositório evoluir além de um único stack
