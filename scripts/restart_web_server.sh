#!/usr/bin/env bash

cd /usr/src/gamification
sudo /var/lib/gamification/bin/python manage.py collectstatic --noinput


sudo service nginx restart
sudo killall -9 uwsgi
sudo /var/lib/gamification/bin/uwsgi --ini /var/lib/gamification/gamification.ini --py-auto-reload=3 &
echo -e "Nginx and uWSGI should have restarted\n"

sudo cp -r /vagrant/gamification-repo/gamification/static/* /usr/src/static/
echo -e "Javascript and css and images were moved to static\n"
