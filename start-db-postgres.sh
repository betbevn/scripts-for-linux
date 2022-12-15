#!/bin/bash
set -e

SERVER='vmo-crypto-local';
PW='g$fKD!sd$101022Lhdev';
DB='vmo-crypto-local';

echo "echo stop & remove old docker [$SERVER]";
echo "echo starting new fresh instance of [$SERVER]"
(docker kill $SERVER || :) && \
  (docker rm $SERVER || :) && \
  docker run --name $SERVER -e POSTGRES_PASSWORD=$PW \
  -e PGPASSWORD=$PW \
  -p 5432:5432 \
  -d postgres

# wait for pg to start
echo "Waiting for [$SERVER] to start";
SLEEP 3;

# create the db 
echo "CREATE DATABASE $DB ENCODING 'UTF-8';" | docker exec -i $SERVER psql -U postgres
echo "CREATE USER vmocryptodev WITH PASSWORD $PW;" | docker exec -i $SERVER psql -U postgres
echo "CREATE USER vmocryptodev WITH PASSWORD $PW;" | docker exec -i $SERVER psql -U postgres
echo "\l" | docker exec -i $SERVER psql -U postgres
