# Instruções para o Ambiente Apache Airflow

Este ambiente utiliza Docker Compose para executar o Apache Airflow em um ambiente linux.

## 1. Inicialização do Ambiente

### 1.1 Pré-requisitos

Certifique-se de ter o Docker e o Docker Compose instalados.

### 1.2 Inicialize o Banco de Dados do Airflow

```bash
docker compose up airflow-init
```

### 1.3 Inicie os Serviços do Airflow

```bash
docker compose up
```

### 1.4 Acesso ao Airflow

O Airflow estará acessível em http://localhost:8080.
- Usuário: airflow
- Senha: airflow

## 2. Entrar no Contêiner do Airflow Worker

Para entrar no contêiner do Airflow Worker:

```bash
docker exec -it <container-id> bash
```

Lembre-se de substituir <container-id> pelo ID do contêiner do Airflow Worker.

## 3. Limpar Tudo (Remover Contêineres, Volumes e Imagens)

Para remover tudo relacionado ao Airflow:

```bash
docker compose down --volumes --rmi all
```

## Observações

O usuário padrão é airflow, e a senha padrão é airflow.