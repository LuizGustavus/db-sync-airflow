cd dbs
docker compose up -d
cd ..
cd airflow
docker compose up airflow-init
docker compose up -d
cd ..
cd k8s
kind create cluster --config kind-config.yaml
kubectl cluster-info
cd ..
cd scripts
docker build -t dbs-sync-script:v1 .
cd ..
cd airflow
eval "docker compose run airflow-cli airflow connections add 'kubernetes_default' --conn-json '{\"conn_type\": \"kubernetes\", \"extra\": {\"kube_config\": $(kubectl config view --minify --raw -o json | sed -e 's#https://127.0.0.1.*#https://kind-control-plane:6443",#' | jq -c | jq -R) }}'"
cd ..
kind load docker-image dbs-sync-script:v1
docker network connect kind airflow-airflow-worker-1
docker network connect dbs_db-sync-network kind-control-plane 
curl -X PATCH 'http://localhost:8080/api/v1/dags/sync_data_dag?update_mask=is_paused' -H 'Content-Type: application/json' --user "airflow:airflow" -d '{"is_paused": false}'
curl -X POST 'http://localhost:8080/api/v1/dags/sync_data_dag/dagRuns' -H 'Content-Type: application/json' --user "airflow:airflow" -d '{}'
