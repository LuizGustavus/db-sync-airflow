kind delete cluster
docker rmi $(docker images 'dbs-sync-script' -a -q)
cd dbs
docker compose down
cd ..
cd airflow
docker compose down --volumes --rmi all
cd ..

sleep 3

cd airflow
docker compose down --volumes --rmi all
cd ..