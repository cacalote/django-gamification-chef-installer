default['gamification']['debug'] = true
default['gamification']['logging']['location'] = '/var/log/gamification'
default['gamification']['virtualenv']['location'] = '/var/lib/gamification'
default['gamification']['location'] = '/usr/src/gamification'
default['gamification']['git_repo']['location'] = 'https://github.com/stephenrjones/django-gamification.git'
default['gamification']['git_repo']['branch'] = 'master'
default['postgresql']['password']['postgres'] = 'jds09K32rj80NLKDIU93l3d'

default['postgresql']['version']                         = '9.3'
default['postgresql']['dir']                             = "/etc/postgresql/9.3/main"
default["postgresql"]["cfg_update_action"]               = :restart
default["postgresql"]["hba_file"]                        = "/etc/postgresql/9.3/main/pg_hba.conf"
default['postgresql']['enable_pgdg_apt']                 = true

default['gamification']['database']['address'] = '127.0.0.1'
default['gamification']['database']['hostname'] = 'localhost'
default['gamification']['database']['name'] = 'gamification'
default['gamification']['database']['user'] = 'game_manager'
default['gamification']['database']['password'] = default['postgresql']['password']['postgres']
default['gamification']['database']['port'] = '5432'

default[:postgis][:version] = '2.1.3'
default['postgis']['template_name'] = 'template0'
default['postgis']['locale'] = 'en_US.utf8'

default['gamification']['settings']['static_root'] = '/usr/src/static'
default['gamification']['settings']['static_url'] = '/static/'

default['gamification']['settings']['DATABASES'] = {
    :default=>{
        :name => node['gamification']['database']['name'],
        :user => node['gamification']['database']['user'],
        :password => node['gamification']['database']['password'],
        :host => node['gamification']['database']['hostname'],
        :port => node['gamification']['database']['port']
        },
    }

