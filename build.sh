#!/usr/bin/bash

log() {
    if [ -z "$QUIET_LOG" ]; then
        echo $@
    fi
}

if [ "$1" == "help" ]; then
    echo "$0        | Build h-e-l-l-o-w-o-r-l-d"
    echo "$0 clean  | Remove all build related files"
    echo "$0 run    | Run hello_world in container"
    echo "$0 shell  | Run shell in container"
    echo "$0 help   | Show this help message"
    exit
fi

if [ -z "$DONT_BUILD_CONTAINER" ]; then
    log "[*] Building container"
    log ""

    docker-compose build --build-arg COMMIT="$(git log -1 --format=%h)"

    log ""
fi

log "[*] Running container"
log ""

CONTAINER_EXEC="time bash -e /code/start-build.sh"
if [ "$1" == "shell" ]; then CONTAINER_EXEC="bash"; fi
if [ "$1" == "clean" ]; then CONTAINER_EXEC="bash /code/clean.sh"; fi
if [ "$1" == "run"   ]; then CONTAINER_EXEC="bash /code/run.sh"; fi

docker-compose run --rm builder $CONTAINER_EXEC
