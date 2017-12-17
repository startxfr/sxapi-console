#!/bin/bash
CWD=$(pwd)

CWS_VERSION="dev"
CONTAINER_VERSION="latest"
CONTAINER_IMAGE="startx/sxapi-console-web"
CWS_PATH=/opt/sxapi-console/cws
CONSOLE_RELEASES=https://api.github.com/repos/startxfr/sxapi-console/tags



function displayUsage {
    cat <<EOF
Usage:
  sxapi-cws COMMAND [ARGS...]
  sxapi-cws COMMAND -h|--help

Command:
  update             Update sxapi-console
  start              Start sxapi-console

Options:
  -v, --version      Print version and exit

Commands:
EOF
exit
}

function displayUpdate { 
    wget $CONSOLE_RELEASES -q -O /tmp/sxapi-console.releases.json
    cat /tmp/sxapi-console.releases.json | jq -r '.[0:4].name'
}

function displayStart { 
    docker run -d --name sxapi-cws $CONTAINER_IMAGE:$CONTAINER_VERSION
}

function displayVersion {
    LONG="1"
    for i in $params
    do
        case $i in
            -s|--short)
            LONG="0"
            ;;
        esac
    done
    
    if  [ "$LONG" -eq "1" ]; then
        echo "sxapi-cws : v$CWS_VERSION"
        echo "path      : $CWS_PATH"
        echo "docker    : v$(docker version --format='{{.Server.Version}}' 2>/dev/null | head -n 1)"
        echo "compose   : $(docker-compose version)"
    else
        echo $CWS_VERSION
    fi
}

key="$1"
params="$@"
case "$key" in
    -v|version)
    displayVersion
    ;;
    -u|update)
    displayUpdate
    ;;
    -s|start)
    displayStart
    ;;
    *)
    displayUsage
    ;;
esac