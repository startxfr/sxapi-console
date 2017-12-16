#!/bin/bash
CWD=$(pwd)

CWS_VERSION="v0.0.8"
CWS_PATH=/opt/sxapi-console/cws

function displayUsage {
    cat <<EOF
Usage:
  sxapi-cws COMMAND [ARGS...]
  sxapi-cws COMMAND -h|--help

Options:
  -v, --version      Print version and exit

Commands:
EOF
exit
}

function checkEnviromentConfig {
    if [ ! -d $CWS_PATH ]; then
        echo " - $CWS_PATH : NOT FOUND"
        echo -n "   Creating $CWS_PATH environement "
        exit;
    fi
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

checkEnviromentConfig
key="$1"
params="$@"
case "$key" in
    -v|version)
    displayVersion
    ;;
    -p|project)
    displayProject
    ;;
    *)
    displayUsage
    ;;
esac