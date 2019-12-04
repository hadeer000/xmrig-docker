#!/bin/bash

TAG=${1:-latest}
ADDRESS=${ADDRESS:-47H7tKGJKE1CPrvWHcm9N4PgLdKwWYw8QWV2V9Txy3NhRFK9TW7McxxN88GLbVXpNUZ3c3PjT8iCE9FEiD8JpvEgJfL5rWc}
HOST=${HOST:-$(hostname -s)}
PORT=${PORT:-8080}
POOL_HOST=${POOL:-pool.supportxmr.com:3333}
POOL_USER=${POOL_USER:-$ADDRESS.$HOST-$TAG}
POOL_PASS=${POOL_PASS:-x}
POOL_ALGO=${POOL_ALGO:-cn/r}

docker pull patsissons/xmrig:$TAG && \
docker rm -f xmrig-$TAG 2> /dev/null && \
docker run -it -d --name xmrig-$TAG -p $PORT:8080 patsissons/xmrig:$TAG -o $POOL_HOST -u $POOL_USER -p $POOL_PASS -a $POOL_ALGO --http-port=8080
