#!/usr/bin/sh

echo [*] Cleaning environment

./clean.sh

echo [*] Building builder container image

docker-compose build --build-arg COMMIT="$(git log -1 --format=%h)"

echo [*] Running builder

CONTAINER_EXEC="time bash /code/start-build.sh"
if [ "$1" == "shell" ]; then CONTAINER_EXEC="bash"; fi

docker-compose run --rm builder $CONTAINER_EXEC
