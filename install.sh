#!/bin/bash
CWD=$(pwd)

CONSOLE_VERSION="dev"
CONSOLE_SOURCE_ZIP="https://codeload.github.com/startxfr/sxapi-console/zip/$CONSOLE_VERSION"
CONSOLE_DEST_PATH="/opt/sxapi-console"

echo "create directory $CONSOLE_DEST_PATH"
mkdir $CONSOLE_DEST_PATH
cd $CONSOLE_DEST_PATH
echo "download sxapi-console version $CONSOLE_VERSION"
wget $CONSOLE_SOURCE_ZIP  -O /tmp/sxapi-console.zip
echo "extracting to $CONSOLE_DEST_PATH"
unzip /tmp/sxapi-console.zip $CONSOLE_DEST_PATH
echo "cleaning binary directory"
rm -rf $CONSOLE_DEST_PATH/install.sh
rm -rf $CONSOLE_DEST_PATH/.gitignore
rm -rf $CONSOLE_DEST_PATH/docs
echo "adding bin to system"
ln -s $CONSOLE_DEST_PATH/cli.sh /usr/local/bin/sxapi-cli
ln -s $CONSOLE_DEST_PATH/cws.sh /usr/local/bin/sxapi-cws
chmod +x /usr/local/bin/sxapi-cws /usr/local/bin/sxapi-cws
echo "ending installation"
cd -
rm $0