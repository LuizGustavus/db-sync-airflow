FROM python:3.8-slim

# Instalar Java (necessário para PySpark)
RUN apt-get update && \
    apt-get install -y default-jdk && \
    rm -rf /var/lib/apt/lists/*

# Instalar PySpark
RUN pip install pyspark

# Definir o diretório de trabalho
WORKDIR /scripts

# Copiar o script PySpark para o diretório de trabalho
COPY db-sync-script.py /scripts/

COPY postgresql-42.7.1.jar /scripts/

# Comando padrão a ser executado quando o contêiner for iniciado
CMD ["spark-submit", "--jars", "postgresql-42.7.1.jar", "db-sync-script.py"]
