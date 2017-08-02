#!/bin/bash
# https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# echo $DIR
FILENAME=$(ls -t "$DIR/releases" | head -n 1)
NO_APP_NAME=$(echo $FILENAME | sed 's/hello_world_edeliver_//g')
VERSION=$(echo $NO_APP_NAME | sed 's/.upgrade.tar.gz//g')
echo $VERSION
