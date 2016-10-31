#!/bin/bash
CWD=$(pwd)

CLI_VERSION="master"
CLI_PATH=~/.sxapi-cli
CLI_PATH_SAMPLE=$CLI_PATH/sample/samples

SAMPLE_PROJECT="sxapi-sample"
SAMPLE_REPO_PROJECT="startxfr/$SAMPLE_PROJECT"
SAMPLE_REPO_VERS="master"
SAMPLE_REPO_VERSION=$SAMPLE_REPO_VERS

#GITHUB_API=https://api.github.com/repos/$SAMPLE_REPO_PROJECT/tags


function displayUsage {
    cat <<EOF
Usage:
  sxapi-cli COMMAND [ARGS...]
  sxapi-cli COMMAND -h|--help

Options:
  -v, --version      Print version and exit

Commands:
  project            project informations
  setup              setup service
  build              build service
  start              start service
  log                log service
  stop               stop service
EOF
exit
}

function displayProject { 
    if [ ! -d $CWD ]; then
        echo "$CWD is not a directory"
        exit;
    fi
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "current directory is not versionned"
        exit;
    fi
    REMOTE_PROJECT_REPO=$(git config --get remote.origin.url)
    echo " - project linked to" $REMOTE_PROJECT_REPO
    exit;
}

function displaySetup {
    arr=(`echo ${params}`);
    MODEL="${arr[1]}"
    if [[ "$MODEL" == "" ]]; then
        MODEL="simple/txt"
    fi
    if [ ! -d $CLI_PATH_SAMPLE/$MODEL ]; then
        echo " - model $MODEL NOT FOUND"
        echo "   choose one of these"
        find $CLI_PATH_SAMPLE -maxdepth 2 -mindepth 2
        exit;
    fi
    
    if [ "$(ls -A $CWD)" ]; then
        echo " - directory is not empty"
        echo -n "   overwrite files [y/N] : "
        read choice
        if  [[  "$choice" == 'y' || "$choice" == 'Y'  ]]; then
            cp -rf $CLI_PATH_SAMPLE/$MODEL/* $CWD/
            cp -rf $CLI_PATH_SAMPLE/$MODEL/.*.yml $CWD/ &> /dev/null
        else 
            exit;
        fi
    else
        cp -rf $CLI_PATH_SAMPLE/$MODEL/* $CWD/
        cp -rf $CLI_PATH_SAMPLE/$MODEL/.*.yml $CWD/ &> /dev/null
    fi
    echo " - project setup with $MODEL"
    exit; 
}

function displayBuild {
    docker-compose build 
}

function displayStart {
    docker-compose up -d 
}

function displayLogs {
    docker-compose logs
}

function displayStop {
    docker-compose kill
    docker-compose rm -f
}

function checkEnviromentConfig {
    if [ ! -d $CLI_PATH ]; then
        echo " - $CLI_PATH : NOT FOUND"
        echo -n "   Creating $CLI_PATH environement "
        mkdir -p $CLI_PATH
        echo "DONE"
    fi
    if [ ! -d $CLI_PATH_SAMPLE ]; then
        echo " - $CLI_PATH_SAMPLE : NOT FOUND"
        echo -n "   Installing $CLI_PATH_SAMPLE "
        mkdir -p $CLI_PATH_SAMPLE
        installSample $CLI_PATH_SAMPLE
    fi
}

function installSample {
    DEST_DIR=${1}
    URL=https://github.com/$SAMPLE_REPO_PROJECT/archive/$SAMPLE_REPO_VERSION.zip
    if curl --output /dev/null --silent --head --fail "$URL"; then
        curl --silent -L "$URL" > $DEST_DIR/$SAMPLE_REPO_VERSION.zip
        cd $DEST_DIR/
        unzip $SAMPLE_REPO_VERSION.zip &> /dev/null
        mv $SAMPLE_PROJECT-$SAMPLE_REPO_VERS/* .
        rm -rf $SAMPLE_REPO_VERSION.zip
        rm -rf $SAMPLE_PROJECT-$SAMPLE_REPO_VERS
        echo "DONE"
    else
        echo "ERROR"
        echo "   Could not download $SAMPLE_PROJECT v$SAMPLE_REPO_VERSION" 
        exit;
    fi
}

function displayVersion {
    LONG="0"
    for i in $params
    do
        case $i in
            -l|--long)
            LONG="1"
            ;;
        esac
    done
    
    if  [ "$LONG" -eq "1" ]; then
    echo "sxapi-cli : v$CLI_VERSION"
    else
    echo $CLI_VERSION
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
    -s|setup)
    displaySetup
    ;;
    build)
    displayBuild
    ;;
    start)
    displayStart
    ;;
    log)
    displayLogs
    ;;
    stop)
    displayStop
    ;;
    *)
    displayUsage
    ;;
esac