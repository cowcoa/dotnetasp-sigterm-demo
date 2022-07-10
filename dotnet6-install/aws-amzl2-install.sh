#!/bin/bash

SHELL_PATH=$(cd "$(dirname "$0")";pwd)

LOCAL_ARCH=$(uname -m)
TARGET_ARCH="x64"
if [ "$LOCAL_ARCH" == "aarch64" ]; then
    TARGET_ARCH="arm64"
fi

${SHELL_PATH}/dotnet-install.sh --arch ${TARGET_ARCH=} --version latest --channel LTS
sudo yum -y install libicu60

# echo '# Set up dotnet env' >> ~/.bashrc
# echo 'export DOTNETPATH=$HOME/.dotnet' >> ~/.bashrc
# echo 'export PATH=$PATH:$DOTNETPATH' >> ~/.bashrc
