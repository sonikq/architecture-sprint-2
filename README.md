# pymongo-api

Ссылка на итоговую диаграмму: https://drive.google.com/file/d/1g3U6RRL8KPYyHbPHlfoOO7aJUhCoP6VN/view?usp=sharing

## Структура файлов

- single: изначальный проект с 1 MongoDB
- sharding: проект с 2 шардами MongoDB
- sharding-repl: проект с 2 шардами MongoDB и 3 репликами каждого шарда
- sharding-repl-cache: проект с 2 шардами MongoDB и 3 репликами каждого шарда и инстансом Redis для кэширования

## Как запустить

Переходим в директорию *sharding-repl-cache*, выполняем 2 команды:

1)Запускаем mongodb и приложение

```shell
docker compose up -d
```

2)Инициализируем конфиг-сервер, шарды, реплики и роутер, а также заполняем mongodb данными.
Скрипты выводят в консоль общее количество созданных документов, а также их количество в каждом шарде

```shell
./scripts/mongo-init.sh
```
## Как проверить

### Если вы запускаете проект на локальной машине

Откройте в браузере http://localhost:8080

```json
{
  "mongo_topology_type": "Sharded",
  "mongo_replicaset_name": null,
  "mongo_db": "somedb",
  "read_preference": "Primary()",
  "mongo_nodes": [
    [
      "mongos_router",
      27024
    ]
  ],
  "mongo_primary_host": null,
  "mongo_secondary_hosts": [],
  "mongo_address": [
    "mongos_router",
    27024
  ],
  "mongo_is_primary": true,
  "mongo_is_mongos": true,
  "collections": {
    "helloDoc": {
      "documents_count": 1000
    }
  },
  "shards": {
    "shard1": "shard1/shard1-1:27018,shard1-2:27019,shard1-3:27020",
    "shard2": "shard2/shard2-1:27021,shard2-2:27022,shard2-3:27023"
  },
  "cache_enabled": true, // кэш(redis) включен
  "status": "OK"
}
```

### Если вы запускаете проект на предоставленной виртуальной машине

Узнать белый ip виртуальной машины

```shell
curl --silent http://ifconfig.me
```

Откройте в браузере http://<ip виртуальной машины>:8080