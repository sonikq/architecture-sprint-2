#!/bin/bash

# Инициализируем конфигурационный сервис
docker compose exec -T configSrv mongosh --port 27017 <<EOF
rs.initiate({_id : "config_server", configsvr: true, members: [{ _id : 0, host : "configSrv:27017" }]})
exit()
EOF

# Инициализируем шард 1
docker compose exec -T shard1 mongosh --port 27018 <<EOF
rs.initiate({_id : "shard1", members: [{ _id : 0, host : "shard1:27018" }]})
exit()
EOF

# Инициализируем шард 2
docker compose exec -T shard2 mongosh --port 27019 <<EOF
rs.initiate({_id : "shard2", members: [{ _id : 0, host : "shard2:27019" }]})
exit()
EOF

# Инициализируем роутер и заполняем базу данными
docker compose exec -T mongos_router mongosh --port 27020 <<EOF
sh.addShard("shard1/shard1:27018")
sh.addShard("shard2/shard2:27019")

sh.enableSharding("somedb")
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )

use somedb

for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})

print("Total number of inserted documents: " + db.helloDoc.countDocuments())
exit()
EOF

# Вывод количества документов в первом шарде
docker compose exec -T shard1 mongosh --port 27018 <<EOF
use somedb
print("Number of documents in shard1: " + db.helloDoc.countDocuments())
exit()
EOF

# Вывод количества документов в втором шарде
docker compose exec -T shard2 mongosh --port 27019 <<EOF
use somedb
print("Number of documents in shard2: " + db.helloDoc.countDocuments())
exit()
EOF