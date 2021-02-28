#!/bin/bash

#### 1. Create a Github Workflow in the Github Repo
#### 2. Get the Runner Token from the repo Actions self-hosted runner

echo "__ App Setup Bash Script"

read -p "__ App name ? " APP_NAME
read -p "__ Github Repo Link ? " REPO_LINK
read -p "__ Github Runner Token ? " GITHUB_RUNNER_TOK

#* create directory in /var/www/$APP_NAME
echo "__ Creating Dir in /var/www/"
sudo mkdir -p /var/www/$APP_NAME && cd /var/www/
SYSTEM_USER_NAME=`whoami`
sudo chown -R $SYSTEM_USER_NAME: $APP_NAME
cd $APP_NAME

#* Downloading Github Self-hosted Runner
echo "__ Installing Github Self-hosted Runner"

GITHUB_ACTION_RUNNER_V=`curl -s "https://api.github.com/repos/actions/runner/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")'`

GITHUB_ACTION_RUNNER_V_NUM=`echo "$GITHUB_ACTION_RUNNER_V" | sed 's/v//'`

GITHUB_ACTION_RUNNER_URI="https://github.com/actions/runner/releases/download/$GITHUB_ACTION_RUNNER_V/actions-runner-linux-x64-$GITHUB_ACTION_RUNNER_V_NUM.tar.gz"

curl -O -L $GITHUB_ACTION_RUNNER_URI

tar xzf ./actions-runner-linux-x64-$GITHUB_ACTION_RUNNER_V_NUM.tar.gz

rm actions-runner-linux-x64-$GITHUB_ACTION_RUNNER_V_NUM.tar.gz


#* Creating the runner and starting the configuration experience
./config.sh --url $REPO_LINK --token $GITHUB_RUNNER_TOK

./run.sh
sudo ./svc.sh install
sudo ./svc.sh start
sudo ./svc.sh status

echo "__ Deleting The Script File"
cd ~
rm -- "$0"