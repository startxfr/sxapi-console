#!/bin/bash
CWD=$(pwd)

CLI_VERSION="v0.0.8"
CLI_PATH=~/.sxapi-cli
CLI_PATH_SAMPLE=$CLI_PATH/sample/samples

SAMPLE_PROJECT="sxapi-sample"
SAMPLE_REPO_PROJECT="startxfr/$SAMPLE_PROJECT"
SAMPLE_REPO_VERS="0.0.6"
SAMPLE_REPO_VERSION="v$SAMPLE_REPO_VERS"

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
  services           list available sample service
  setup              setup service
  start              start service
  log                log service
  stop               stop service
  restart            restart service
  record             record change into your project [major,minor or release]
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
    echo " - list of version for this project"
    git tag
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

function displayService {
    cd $CLI_PATH_SAMPLE
    echo " availables services for $SAMPLE_PROJECT $SAMPLE_REPO_VERSION"
    find . -maxdepth 2 -mindepth 2 -type d
    cd -
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

function displayRestart {
    displayStop
    displayStart
}

function displayRecord {
    arr=(`echo ${params}`);
    PARAM_MAJOR="${arr[1]}"
    if [[ "$PARAM_MAJOR" = "maj" || "$PARAM_MAJOR" = "major" ]]; then
        ISMAJOR='yes'
    else
        ISMAJOR='no'
    fi
    if [[ "$PARAM_MAJOR" = "min" || "$PARAM_MAJOR" = "minor" ]]; then
        ISMINOR='yes'
    else
        ISMINOR='no'
    fi
    SERVICE_VERSION=`git tag | sort -V | tail -1`
    SERVICE_VERSION_FIRST=${SERVICE_VERSION:0:1}
    if [[ $SERVICE_VERSION == "" ]]; then
        SERVICE_VERSION="0.0.0"
        echo " - creating first release"
    else
        if [[ $SERVICE_VERSION_FIRST == 'v' ]]; then
            SERVICE_VERSION=${SERVICE_VERSION:1}
        fi
    fi
    IFSO=$IFS
    IFS='.'
    eval 'a=($SERVICE_VERSION)'
    IFS=$IFSO
    SERVICE_V_MAJ=${a[0]}
    SERVICE_V_MIN=${a[1]}
    SERVICE_V_REL=${a[2]}
    if [ $ISMAJOR == 'yes' ]; then
        SERVICE_V_MAJ=$(($SERVICE_V_MAJ+1))
        SERVICE_V_MIN="0"
        SERVICE_V_REL="0"
    else if [ $ISMINOR == 'yes' ]; then
        SERVICE_V_MIN=$(($SERVICE_V_MIN+1))
        SERVICE_V_REL="0"
    else
        SERVICE_V_REL=$(($SERVICE_V_REL+1))
        fi
    fi
    NEW_VERSION="$SERVICE_V_MAJ.$SERVICE_V_MIN.$SERVICE_V_REL"
    echo " - curent version : " $SERVICE_VERSION
    echo " -   next version : " $NEW_VERSION
    echo "   type Ctrl+C if you want to abort recording"
    echo -n "   record description : "
    read message
    if [ ! "$message" == '' ]; then
        git add .
        git add ./*
        eval git commit -m \"$message\"
        eval git tag -a v$NEW_VERSION -m \"release v$NEW_VERSION\"
        git push origin v$NEW_VERSION
    fi
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
        echo "sxapi-cli : v$CLI_VERSION"
        echo "sxapi-sample : v$SAMPLE_REPO_VERSION"
        echo "docker : v$(docker version --format='{{.Server.Version}}' 2>/dev/null | head -n 1)"
        echo "$(docker-compose version)"
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
    services)
    displayService
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
    record)
    displayRecord
    ;;
    restart)
    displayRestart
    ;;
    *)
    displayUsage
    ;;
esac