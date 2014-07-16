#!/usr/bin/env bash

sudo mkdir -p /usr/src/gamification/badge_images
sudo rm /usr/src/static/badge_images 2> /dev/null
sudo ln -s /usr/src/gamification/badge_images badge_images