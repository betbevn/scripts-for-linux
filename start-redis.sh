#!/bin/bash
set -e


SERVER="redis-local";
PW="5hGH+f62RFO9GK22YUy3WbPzhPNV8fdjMI3XA2UabAflskDgiinSDgkor6QRyf7Jt8xBygmxXVK14snV%"


echo "stop & remove old docker [$SERVER]";
echo "starting new fresh instance of [$SERVER]";

(docker kill $SERVER || :) && \
  (docker rm $SERVER || :) && \
  docker run --name $SERVER \
  -p 6379:6379 \
  -d redis redis-server --requirepass $PW


# wait for redis to start
echo "Waiting for [$SERVER] to start";
SLEEP 3;