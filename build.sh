#!/usr/bin/bash

log() {
    if [ -z "$QUIET_LOG" ]; then
        echo $@
    fi
}

if [ -z "$DONT_BUILD_CONTAINER" ]; then
    log "[*] Building container"
    log ""

    docker-compose build --build-arg COMMIT="$(git log -1 --format=%h)"

    log ""
fi

if [ -z "$1" ]; then CONTAINER_EXEC="time bash -e /code/start-build.sh";
elif [ "$1" == "shell" ]; then CONTAINER_EXEC="bash";
elif [ "$1" == "clean" ]; then CONTAINER_EXEC="bash /code/clean.sh";
elif [ "$1" == "run"   ]; then CONTAINER_EXEC="bash /code/run.sh";
else
    echo "$0        | Build h-e-l-l-o-w-o-r-l-d"
    echo "$0 clean  | Remove all build related files"
    echo "$0 run    | Run hello_world in container"
    echo "$0 shell  | Run shell in container"
    echo "$0 help   | Show this help message"
    exit
fi

log "[*] Running container"
log ""

docker-compose run --rm builder $CONTAINER_EXEC
