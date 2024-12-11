#!/usr/bin/bash

echo [*] Building builder container image

docker-compose build --build-arg COMMIT="$(git log -1 --format=%h)"

echo [*] Running builder

CONTAINER_EXEC="time bash /code/start-build.sh"
if [ "$1" == "shell" ]; then CONTAINER_EXEC="bash"; fi
if [ "$1" == "clean" ]; then CONTAINER_EXEC="bash /code/clean.sh"; fi

docker-compose run --rm builder $CONTAINER_EXEC
