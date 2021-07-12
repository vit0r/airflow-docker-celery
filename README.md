# Pre

[install-compose](https://docs.docker.com/compose/install/#install-compose)

```language
sudo sh celery/gencert.sh
sudo sh rabbitmq/gencert.sh
sudo sh webserver/gencert.sh
```

# Airflow docker

```bash
docker-compose down
docker-compose up -d
```