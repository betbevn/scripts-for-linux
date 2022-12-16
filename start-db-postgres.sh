#!/bin/bash
set -e

SERVER="vmo-crypto-local";
USER="vmocryptolocal";
PW="'gfKDsd101022Lhdev'";
DB='"vmo-crypto-local"';

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

# create the user 
echo "CREATE USER $USER WITH PASSWORD $PW;" | docker exec -i $SERVER psql -U postgres
echo "ALTER USER $USER WITH LOGIN;" | docker exec -i $SERVER psql -U postgres

# create the grant connect database to user
echo "GRANT CONNECT ON DATABASE $DB TO $USER;" | docker exec -i $SERVER psql -U postgres
echo "GRANT ALL PRIVILEGES ON DATABASE $DB to $USER;" | docker exec -i $SERVER psql -U postgres

# another way to execute commnd like echo
docker exec -i $SERVER psql -U postgres << EOF 
\c $DB;
GRANT ALL ON SCHEMA public TO $USER;
EOF

echo "\l" | docker exec -i $SERVER psql -U postgres
