#!/bin/bash
CWD=$(pwd)

CONSOLE_VERSION="dev"
CONSOLE_SOURCE_ZIP="https://codeload.github.com/startxfr/sxapi-console/zip/$CONSOLE_VERSION"
CONSOLE_DEST_PATH="/opt/sxapi-console"

echo "install dependencies"
sudo yum install -y wget git curl jq docker zip
echo "start docker"
sudo service docker start
echo "create directory $CONSOLE_DEST_PATH"
sudo rm -rf $CONSOLE_DEST_PATH
sudo mkdir $CONSOLE_DEST_PATH
sudo cd $CONSOLE_DEST_PATH
echo "download sxapi-console version $CONSOLE_VERSION"
sudo git clone https://github.com/startxfr/sxapi-console.git $CONSOLE_DEST_PATH
echo "cleaning binary directory"
sudo rm -rf $CONSOLE_DEST_PATH/install.sh
sudo rm -rf $CONSOLE_DEST_PATH/.git
sudo rm -rf $CONSOLE_DEST_PATH/.gitignore
sudo rm -rf $CONSOLE_DEST_PATH/docs
echo "adding bin to system"
sudo rm -rf /usr/local/bin/sxapi-cli
sudo ln -s $CONSOLE_DEST_PATH/cli.sh /usr/local/bin/sxapi-cli
sudo chmod +x $CONSOLE_DEST_PATH/cli.sh
sudo rm -rf /usr/local/bin/sxapi-cws
sudo ln -s $CONSOLE_DEST_PATH/cws.sh /usr/local/bin/sxapi-cws
sudo chmod +x $CONSOLE_DEST_PATH/cws.sh
echo "ending installation"
sudo cd $CWD
rm $0