# Bancos de Dados PostgreSQL com Docker Compose

## Instruções

1. Execute o Docker Compose para iniciar os bancos de dados.

```bash
docker compose up
```

2. Aguarde até que os bancos de dados estejam prontos.

3. Os bancos de dados devem estar disponíveis nos seguintes endereços:

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

## Observações

- Os bancos de dados serão inicializados com tabelas e dados de exemplo.
- Para parar e remover os bancos de dados, execute:

```bash
docker-compose down 
```