#!/bin/bash

function displayStartCli {
    echo "" 
    echo "==================================" 
    echo "== SXAPI CLI (dev)"
    echo "==================================" 
    echo ""
}
function displayMenu { 
    echo "1. New microservice"
    echo "2. Use microservice"
    echo -n "Enter your choice : "
    read menu
    if  [  "$menu" == "1"  ]; then
        displayNewMicroservice
    elif  [  "$menu" == "2"  ]; then
        displayNewMicroservice
        exit 1
    else
        displayMenu
    fi
}

function displayNewMicroservice { 
        echo "--- New microservice"
    echo -n "service name : "
    read name
}


function checkRootAccess {
    if [ "$(id -u)" != "0" ]; then
        echo "! This script must be run as root"
        echo "! Please run 'su root' and start again"
        echo "! this installer"
        exit;
    else 
        echo " - root access : OK"
    fi
}

function checkEnviromentConfig {
    CLI_PATH=/var/sxapi-cli
    CLI_PATH_SAMPLE=$CLI_PATH/sample
    if [ ! -d $CLI_PATH ]; then
        echo " - $CLI_PATH : NOT FOUND"
        echo -n "   Creating $CLI_PATH environement "
        mkdir -p $CLI_PATH
        echo "DONE"
    else 
        echo " - $CLI_PATH : FOUND"
    fi
    if [ ! -d $CLI_PATH_SAMPLE ]; then
        echo " - $CLI_PATH_SAMPLE : NOT FOUND"
        echo -n "   Installing $CLI_PATH_SAMPLE "
        mkdir -p $CLI_PATH_SAMPLE
        installSample $CLI_PATH_SAMPLE
        echo "DONE"
    else 
        echo " - $CLI_PATH_SAMPLE : FOUND"
    fi
}

function installSample {
    DEST_DIR=${1}
    VERSION="dev"
    URL=https://github.com/startxfr/sxapi-sample/archive/$VERSION.zip
    if curl --output /dev/null --silent --head --fail "$URL"; then
            curl --silent -L "$URL" > $DEST_DIR/$VERSION.zip
            cd $DEST_DIR/
            unzip $VERSION.zip &> /dev/null
            mv sxapi-sample-dev/* .
            rm -rf $VERSION.zip
            rm -rf sxapi-sample-$VERSION
            echo "DONE"
        else
            echo "ERROR"
            echo "   Could not download sxapi-sample v$VERSION" 
            exit;
        fi
}

displayStartCli
checkRootAccess
checkEnviromentConfig
displayMenu