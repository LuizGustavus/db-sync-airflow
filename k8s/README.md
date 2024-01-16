# Cluster Kubernetes com Kind

## Requisitos

- Docker instalado: [Download Docker](https://www.docker.com/get-started)
- Kind instalado: [Instruções de Instalação do Kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)

**Nota:** Este guia assume que você está usando um ambiente Linux.

## Como Rodar o Cluster

1. Crie o cluster Kubernetes usando Kind.

```bash
kind create cluster --config kind-config.yaml
```

2. Aguarde até que o cluster seja criado com sucesso.

3. Para verificar o status do cluster, execute:

```bash
kubectl cluster-info
```

4. O cluster deve estar pronto para uso.

##  Observações

- Certifique-se de que o Docker e o Kind estão instalados corretamente.
- Para excluir o cluster, execute:

```bash
kind delete cluster
```

Isso encerrará o cluster e removerá os recursos associados.