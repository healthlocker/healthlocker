#!/bin/bash

# This Bash Script has/does One Job: Return the Latest Version of the app to be deployed.
# The reason for using the Git Hash in the version of the app being deployed e.g: f012e96
# so that we can search for it on GitHub and know which version of the code we are running
# e.g: https://github.com/nelsonic/hello_world_edeliver/search?q=f012e96&type=Commits

# get the current directory (.deliver) see: https://stackoverflow.com/questions/59895/
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# list files by creation time (most recent first) and return the first one (latest release)
FILENAME=$(ls -t "$DIR/releases" | head -n 1) # e.g: healthlocker_0.0.3+f012e96.upgrade.tar.gz

# strip the name of the project from the FILENAME:
NO_APP_NAME=$(echo $FILENAME | sed 's/healthlocker__//g') # e.g: 0.0.3+f012e96.upgrade.tar.gz

 # remove the ".upgrade.tar.gz" suffix to leave just the version:
VERSION=$(echo $NO_APP_NAME | sed 's/.upgrade.tar.gz//g') # e.g: 0.0.3+f012e96

# return the upgrade version for use in "mix edeliver deploy upgrade" command:
echo $VERSION # e.g: 0.0.3+f012e96 which is the version in mix.exs + short git hash: f012e96
