# Projeto de Sincronização de Dados

## Introdução

Este projeto visa demonstrar a sincronização de dados entre bancos de dados PostgreSQL usando Apache Airflow, Kubernetes e PySpark. A sincronização é realizada através de uma DAG (Directed Acyclic Graph) no Apache Airflow, que aciona um script PySpark em um pod do Kubernetes para transferir dados entre os bancos de dados.

**Nota:** Este projeto foi preparado e testado para rodar em ambientes Linux. Algumas instruções podem variar em outros sistemas operacionais.

## Pré-requisitos

Certifique-se de ter os seguintes pré-requisitos instalados em seu ambiente:

- Docker: [Instruções de instalação do Docker](https://docs.docker.com/get-docker/)
- Docker Compose [Instruções de instalação do Docker Compose](https://docs.docker.com/compose/install/)
- kind: [Instruções de instalação do kind](https://kind.sigs.k8s.io/docs/user/quick-start/)
- kubectl: [Instruções de instalação do kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- jq: [Instruções de instalação do jq](https://stedolan.github.io/jq/download/)

## Estrutura do Projeto

O projeto está organizado nas seguintes pastas e arquivos:

- **airflow/:** Contém os arquivos necessários para configurar e rodar o Apache Airflow localmente, incluindo a DAG para sincronização de dados.

  - **config/**: Diretório de arquivos de configuração específicas do Apache Airflow.
  - **dags/**: Diretório para armazenar dags do Apache Airflow.
    - **sync_data_dag.py**: Definição da DAG (Directed Acyclic Graph) para sincronização de dados.
  - **logs/**: Diretório para armazenar logs do Apache Airflow.
  - **plugins/**: Diretório para plugins customizados do Apache Airflow.
  - **.env**: Arquivo de configuração contendo variáveis de ambiente para o Apache Airflow.
  - **docker-compose.yaml**: Configuração do Docker Compose para subir o ambiente do Apache Airflow.
  - **README.md**: Documentação com instruções e informações sobre o ambiente do Apache Airflow.

- **dbs/:** Contém os scripts e configurações necessários para criar os bancos de dados PostgreSQL localmente.

  - **docker-compose.yaml**: Configuração do Docker Compose para subir os bancos de dados PostgreSQL localmente.
  - **init-projects-db.sql**: Script SQL para inicializar o banco de dados 'projects'.
  - **init-users-db.sql**: Script SQL para inicializar o banco de dados 'users'.
  - **README.md**: Documentação com instruções sobre a criação dos bancos de dados PostgreSQL.

- **k8s/:** Contém os arquivos necessários para criar um cluster Kubernetes local usando kind.

  - **kind-config.yaml**: Configuração do cluster Kubernetes usando o Kind.
  - **README.md**: Documentação com instruções sobre a criação do cluster Kubernetes.

- **scripts/:** Contém o script PySpark para sincronização de dados entre os bancos PostgreSQL, além de informações sobre como criar a imagem Docker para o script.

  - **db-sync-script.py**: Script em Python com PySpark para sincronizar dados entre os bancos 'users' e 'projects'.
  - **Dockerfile**: Arquivo Dockerfile para construir a imagem necessária.
  - **postgresql-42.7.1.jar**: Pacote com dependências, incluindo o driver JDBC do PostgreSQL, necessário para a conexão PySpark.
  - **README.md**: Documentação com instruções sobre a utilização do script e construção da imagem Docker.

- **.gitignore**: Arquivo de configuração do Git para ignorar determinados arquivos e diretórios.

- **delete.sh**: Script automatizado responsável por apagar todos os recursos gerados, limpando o ambiente.

- **README.md**: Documentação com instruções sobre o projeto.

- **run.sh**: Script automatizado responsável por instanciar todos os recursos do projeto e executar todos os passos descritos nas instruções de uso.

## Instruções de Uso

### 1. Criar Bancos de Dados PostgreSQL

1. Navegue para o diretório `dbs`.

```bash
cd dbs
```

2. Execute o Docker Compose para iniciar os bancos de dados.

```bash
docker compose up -d
```

3. Aguarde até que os bancos de dados estejam prontos.

4. Os bancos de dados devem estar disponíveis nos seguintes endereços:

- Banco de dados 'users':

  - Host: localhost
  - Porta: 5433
  - Usuário: postgres
  - Senha: postgres
  - Nome do Banco de Dados: users

- Banco de dados 'projects':
  - Host: localhost
  - Porta: 5434
  - Usuário: postgres
  - Senha: postgres
  - Nome do Banco de Dados: projects

5. Navegue para o diretório raiz do projeto.

```bash
cd ..
```

#### Observações

- Os bancos de dados serão inicializados com tabelas e dados de exemplo.

### 2. Rodar o Apache Airflow

1. Navegue para o diretório `airflow`.

```bash
cd airflow
```

2. Inicialize o Banco de Dados do Airflow

```bash
docker compose up airflow-init
```

3. Aguarde até que o banco de dados do Airflow esteja pronto.

4. Inicie os Serviços do Airflow

```bash
docker compose up -d
```

5. Acesso ao Airflow

O Airflow estará acessível em http://localhost:8080.

- Usuário: airflow
- Senha: airflow

6. Navegue para o diretório raiz do projeto.

```bash
cd ..
```

### 3. Criar o Cluster Kubernetes

1. Navegue para o diretório `k8s`.

```bash
cd k8s
```

2. Crie o cluster Kubernetes usando Kind.

```bash
kind create cluster --config kind-config.yaml
```

3. Aguarde até que o cluster seja criado com sucesso.

4. Para verificar o status do cluster, execute:

```bash
kubectl cluster-info
```

5. O cluster deve estar pronto para uso.

6. Navegue para o diretório raiz do projeto.

```bash
cd ..
```

### 4. Buildar a Imagem Docker

1. Navegue para o diretório `scripts`.

```bash
cd scripts
```

2. Crie a imagem usando o seguinte comando:

```bash
docker build -t dbs-sync-script:v1 .
```

Isso irá construir a imagem Docker com o nome `dbs-sync-script`.

3. Navegue para o diretório raiz do projeto.

```bash
cd ..
```

#### Observações

- Esta imagem Docker será utilizada pelo Apache Airflow para executar o script PySpark como parte da sincronização de dados entre bancos de dados.

Antes de acionar a DAG para sincronizar os dados, alguns passos adicionais são necessários para configurar o ambiente. Execute os seguintes passos:

### 5. Configurar Conexão do Airflow com o Kubernetes

Para que o Apache Airflow possa criar um pod no ambiente do Kubernetes, execute os seguintes comandos para adicionar a conexão no Apache Airflow:

#### Observação: certifique-se de estar no diretório `airflow`

```bash
cd airflow
eval "docker compose run airflow-cli airflow connections add 'kubernetes_default' --conn-json '{\"conn_type\": \"kubernetes\", \"extra\": {\"kube_config\": $(kubectl config view --minify --raw -o json | sed -e 's#https://127.0.0.1.*#https://kind-control-plane:6443",#' | jq -c | jq -R) }}'"
cd ..
```

Este comando configura a conexão chamada 'kubernetes_default' para o Kubernetes usando o arquivo de configuração obtido do ambiente Kind.

### 6. Inserir Imagem Local no Kubernetes

Para carregar a imagem local `dbs-sync-script:v1` no Kind para que o Kubernetes possa usá-la, execute o seguinte comando:

```bash
kind load docker-image dbs-sync-script:v1
```

Este comando assegura que o Kubernetes pode acessar a imagem Docker dbs-sync-script:v1 que será utilizada na execução da tarefa de sincronização.

### 7. Associar Docker Network do Kubernetes com o Container Worker do Airflow:

Para conectar a rede do ambiente Kubernetes com o container Worker do Apache Airflow, execute o seguinte comando:

```bash
docker network connect kind airflow-airflow-worker-1
```

Esta etapa garante a comunicação entre o ambiente Kubernetes e o Apache Airflow.

### 8. Associar Docker Network dos Bancos de Dados com o Ambiente Kubernetes:

Para conectar a rede do ambiente dos bancos de dados com o ambiente Kubernetes, permitindo que o pod que realizará a sincronização possa acessar os bancos de dados, execute o seguinte comando:

```bash
docker network connect dbs_db-sync-network kind-control-plane
```

Esta ação estabelece a comunicação entre o pod do Kubernetes e os bancos de dados PostgreSQL.

### 9. Entrar na DAG no Apache Airflow e Ativar a DAG

Acesse a interface do Apache Airflow no navegador usando a seguinte URL: [http://localhost:8080](http://localhost:8080). Faça login com as credenciais padrão (usuário: `airflow`, senha: `airflow`). Navegue até a página `DAGs` e localize a DAG chamada `sync_data_dag`. Ative a DAG para permitir sua execução.

### 10. Acionar a DAG via Linha de Comando utilizando a API do Apache Airflow ou via Interface Web manualmente

- Para acionar via Linha de Comando utilizando a API do Apache Airflow

1. Execute o seguinte comando no terminal para despausar a DAG:

```bash
curl -X PATCH 'http://localhost:8080/api/v1/dags/sync_data_dag?update_mask=is_paused' \
-H 'Content-Type: application/json' \
--user "airflow:airflow" \
-d '{"is_paused": false}'
```

2. Execute o seguinte comando no terminal para acionar a DAG:

```bash
curl -X POST 'http://localhost:8080/api/v1/dags/sync_data_dag/dagRuns' \
-H 'Content-Type: application/json' \
--user "airflow:airflow" \
-d '{}'
```

- Para acionar via Interface Web manualmente

1. Abra o navegador e acesse a interface web do Apache Airflow. O endereço é [http://localhost:8080](http://localhost:8080).

2. Faça login com as credenciais fornecidas (usuário: airflow, senha: airflow).

3. Na barra de navegação superior, clique na aba "DAGs" para acessar a lista de DAGs disponíveis.

4. Localize a DAG específica `sync_data_dag` para a sincronização de dados entre os bancos e clique sobre o seu nome para acessar a página detalhada da DAG.

5. Na página da DAG, clique no botão de ligar/desligar (normalmente chamado "Off" ou "On") para ativar a DAG.

6. Clique no botão "Trigger DAG" para iniciar a execução da DAG manualmente.

7. Aguarde o progresso da execução na interface web. Você pode visualizar logs e detalhes de execução na própria interface.

### 11. Remover todos os recursos criados

- Para parar e remover os bancos de dados, certifique-se de estar no diretório `dbs`, execute:

```bash
cd dbs
docker-compose down
cd ..
```

- Para remover tudo (contêineres, volumes e imagens) relacionado ao Airflow, certifique-se de estar no diretório `airflow`, execute:

```bash
cd airflow
docker compose down --volumes --rmi all
cd ..
```

- Para excluir o cluster kubernets e remover os recursos associados, execute:

```bash
kind delete cluster
```

- Para excluir a imagem criada que executa o sincronismo entre os bancos, execute:

```bash
docker rmi $(docker images 'dbs-sync-script' -a -q)
```

## Observações

- Caso prefira, você pode usar os seguintes scripts bash para automatizar operações relacionadas ao projeto:

  - `run.sh`: Este script é responsável por instanciar todos os recursos do projeto e executar todos os passos descritos nas instruções de uso.

  - `delete.sh`: Este script é responsável por apagar todos os recursos gerados, limpando o ambiente.
