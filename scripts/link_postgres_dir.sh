#!/usr/bin/env bash

sudo mkdir -p /var/lib/postgresql/9.3
sudo rm /var/lib/postgresql/9.1 2> /dev/null
sudo ln -s /var/lib/postgresql/9.3 /var/lib/postgresql/9.1 2> /dev/null
sudo rm /etc/postgresql/9.1 2> /dev/null
sudo ln -s /etc/postgresql/9.3 /etc/postgresql/9.1 2> /dev/null
