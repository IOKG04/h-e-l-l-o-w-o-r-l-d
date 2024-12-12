#!/usr/bin/bash

if [ "$1" == "help" ]; then
    echo "$0        | Build h-e-l-l-o-w-o-r-l-d"
    echo "$0 clean  | Remove all build related files"
    echo "$0 run    | Run hello_world in container"
    echo "$0 shell  | Run shell in container"
    echo "$0 help   | Show this help message"
    exit
fi

echo "[*] Building container"
echo ""

if [ "$1" == "SILENTIO" ]; then # a thing because of server_test.sh, which would prefer only the needed output
    docker-compose build --build-arg COMMIT="$(git log -1 --format=%h)" > /dev/null 2> /dev/null
else
    docker-compose build --build-arg COMMIT="$(git log -1 --format=%h)"
fi

echo ""
echo "[*] Running container"
echo ""

CONTAINER_EXEC="time bash /code/start-build.sh"
if [ "$1" == "shell" ]; then CONTAINER_EXEC="bash"; fi
if [ "$1" == "clean" ]; then CONTAINER_EXEC="bash /code/clean.sh"; fi
if [ "$1" == "run"   ]; then CONTAINER_EXEC="bash /code/run.sh"; fi

docker-compose run --rm builder $CONTAINER_EXEC
