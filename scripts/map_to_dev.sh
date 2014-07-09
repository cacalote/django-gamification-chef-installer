#!/usr/bin/env bash

cd /usr/src
sudo mv gamification gamification.github
sudo ln -s /vagrant/gamification-repo gamification
sudo source /vagrant/scripts/restart_web_server.sh