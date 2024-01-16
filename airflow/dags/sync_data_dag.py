from datetime import datetime, timedelta
from airflow import DAG
from airflow.providers.cncf.kubernetes.operators.pod import KubernetesPodOperator
from airflow.operators.dummy import DummyOperator

# Defina as configurações padrão da DAG
default_args = {
    'owner': 'airflow',
    'start_date': datetime(2024, 1, 1),
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Defina a DAG
dag = DAG(
    'sync_data_dag',
    default_args=default_args,
    description='DAG para sincronizar dados entre bancos PostgreSQL usando Kubernetes',
    schedule_interval=None,  # Remova o agendamento automático
)

# Tarefas da DAG
start_task = DummyOperator(task_id='start_task', dag=dag)

# Configurar um Pod no Kubernetes para executar a tarefa PySpark
sync_data_task = KubernetesPodOperator(
    task_id='sync_data_task',
    namespace='default',
    image='dbs-sync-script:v1',  # Substitua pelo nome da sua imagem leve com PySpark
    dag=dag,
)

end_task = DummyOperator(task_id='end_task', dag=dag)

# Configurar dependências entre as tarefas
start_task >> sync_data_task >> end_task
