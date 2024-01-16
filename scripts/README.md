# Scripts

Esta pasta contém scripts relevantes para o projeto de sincronização de dados entre bancos de dados PostgreSQL usando Apache Airflow e Kubernetes.

## Pré-requisitos

- Docker instalado: [Instruções de instalação do Docker](https://docs.docker.com/get-docker/)
- Comandos básicos do Docker conhecidos

## Criação da Imagem Docker

Para criar a imagem Docker necessária para executar o script PySpark, siga estas etapas:

1. Certifique-se de estar no diretório `scripts`.

2. Crie a imagem usando o seguinte comando:

   ```bash
   docker build -t dbs-sync-script .
   ```

   Isso irá construir a imagem Docker com o nome `dbs-sync-script`.

## Utilização da Imagem Docker

Esta imagem Docker será utilizada pelo Apache Airflow para executar o script PySpark como parte da sincronização de dados entre bancos de dados.

Certifique-se de ter a imagem disponível no ambiente onde o Apache Airflow está sendo executado.
