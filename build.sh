#!/usr/bin/bash

LOG_LEVEL="1"

log() {
    if [ "$LOG_LEVEL" == "1" ]; then
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

# Not user-facing, meant for github actions
if [ "$1" == "NO_LOG" ]; then
    LOG_LEVEL="0"
    DC_EXTRA_FLAGS=" 2>&1 > /dev/null"
fi

log "[*] Building container"
log ""

bash -c "docker-compose build --build-arg COMMIT="$(git log -1 --format=%h)" $DC_EXTRA_FLAGS"

log ""
log "[*] Running container"
log ""

CONTAINER_EXEC="time bash /code/start-build.sh"
if [ "$1" == "shell" ]; then CONTAINER_EXEC="bash"; fi
if [ "$1" == "clean" ]; then CONTAINER_EXEC="bash /code/clean.sh"; fi
if [ "$1" == "run"   ]; then CONTAINER_EXEC="bash /code/run.sh"; fi

docker-compose run --rm builder $CONTAINER_EXEC
