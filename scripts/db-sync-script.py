from pyspark.sql import SparkSession
from pyspark.sql.functions import col

# Configurações do Spark
spark = SparkSession.builder.appName("DBSync").getOrCreate()

# Configurações do banco de dados source (users)
source_db_url = "jdbc:postgresql://postgres_users:5432/users"
source_db_properties = {
    "user": "postgres",
    "password": "postgres",
    "driver": "org.postgresql.Driver",
}

# Configurações do banco de dados destination (projects)
destination_db_url = "jdbc:postgresql://postgres_projects:5432/projects"
destination_db_properties = {
    "user": "postgres",
    "password": "postgres",
    "driver": "org.postgresql.Driver",
}

# Carregar dados da tabela user do banco de dados source (users)
df_source = spark.read.jdbc(url=source_db_url, table="public.user", properties=source_db_properties)

# Selecionar colunas necessárias
selected_columns = ["id", "name"]
df_selected = df_source.select(*selected_columns)

# Escrever dados na tabela user do banco de dados destination (projects)
df_selected.write.jdbc(url=destination_db_url, table="public.user", mode="overwrite", properties=destination_db_properties)

# Encerrar a sessão Spark
spark.stop()
