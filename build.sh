#!/usr/bin/env sh

#fail on error
set -e

NAME="backup-transactions"
REPOSITORY_URL="registry.digitalocean.com/thorwallet-repository"

is_logged_in() {
  cat ~/.docker/config.json | jq -r --arg url "${REPOSITORY_URL}" '.auths | has($url)'
}

alpine_docker_with_push() {
  echo "Starting docker with alpine, about to build [$NAME]"
  docker run -v /var/run/docker.sock:/var/run/docker.sock -v `pwd`:/root -it --rm alpine ash -c "/root/build.sh go"
  echo "Build complete"
  if ! is_logged_in; then
    echo "Login to $REPOSITORY_URL"
    docker login $REPOSITORY_URL
  fi
  echo "Pushing [$REPOSITORY_URL/$NAME:latest]"
  docker push $REPOSITORY_URL/$NAME:latest
  echo "Pushed."
}

if [ "$1" != "go" ]; then
  alpine_docker_with_push
else
  apk add --no-cache docker
  cd /root
  docker build --build-arg DB_TO_RESTORE_CONNECTION="postgresql://stage-analytics-db:1XUB3xy5z2woSxC9@app-0c131e06-bd1e-42f9-8309-02a344e26e72-do-user-10108618-0.b.db.ondigitalocean.com:25060/stage-analytics-db?sslmode=require" --build-arg DB_TO_DUMP_CONNECTION="postgresql://stage-mainnet-tw-backend-db:7wuBtkwRWuVuzMxE@app-a22cf0e9-f813-45e7-93d9-c7c45a3d494c-do-user-10108618-0.b.db.ondigitalocean.com:25060/stage-mainnet-tw-backend-db?sslmode=require" . -t $NAME
  docker image tag $NAME:latest $REPOSITORY_URL/$NAME:latest
fi