# Infraestrutura de Service Mesh no Google Cloud Platform

## Pré-requisitos

* [Cloud SDK](https://cloud.google.com/sdk/install)
* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)

## Começando

## Credenciais do GCP

Para obter as credenciais do GCP, utilize-se do SDK do Cloud na máquina local ou no Cloud Shell e execute os seguintes comandos usando o 

Crie a conta de serviço. Substitua [NAME] por um nome para a conta de serviço.
```bash
gcloud iam service-accounts create [NAME]
```

Conceda permissões à conta de serviço. Substitua [PROJECT-ID] pelo ID do projeto.
```bash
gcloud projects add-iam-policy-binding [PROJECT_ID] --member "serviceAccount:[NAME]@[PROJECT_ID].iam.gserviceaccount.com" --role "roles/owner"
```

Gere o arquivo de chave. Substitua [FILE_NAME] pelo nome do arquivo de chave.
```bash
gcloud iam service-accounts keys create [FILE_NAME].json --iam-account [NAME]@[PROJECT_ID].iam.gserviceaccount.com
```