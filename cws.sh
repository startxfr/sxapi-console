#!/bin/bash
CWD=$(pwd)

CWS_VERSION="dev"
CWS_PATH=~/.sxapi-cws

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
        mkdir -p $CWS_PATH
        echo "DONE"
    fi
    if [ ! -d $CWS_PATH_SAMPLE ]; then
        echo " - $CWS_PATH_SAMPLE : NOT FOUND"
        echo -n "   Installing $CWS_PATH_SAMPLE "
        mkdir -p $CWS_PATH_SAMPLE
        installSample $CWS_PATH_SAMPLE
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