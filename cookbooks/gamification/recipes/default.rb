gamification_pkgs = "build-essential python-dev libpq-dev libpng-dev libfreetype6 libfreetype6-dev".split

gamification_pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

python_virtualenv node['gamification']['virtualenv']['location'] do
  interpreter "python2.7"
  action :create
end

python_pip "uwsgi" do
  virtualenv node['gamification']['virtualenv']['location']
end

git node['gamification']['location'] do
  repository node['gamification']['git_repo']['location']
  revision node['gamification']['git_repo']['branch']
  action :sync
  notifies :run, "execute[install_gamification_dependencies]", :immediately
  notifies :run, "bash[sync_db]"
  notifies :run, "execute[install_dev_fixtures]"
end

execute "install_gamification_dependencies" do
  command "#{node['gamification']['virtualenv']['location']}/bin/pip install --upgrade -r requirements.txt"
  cwd node['gamification']['location']
  action :nothing
  user 'root'
end

execute "install_dev_fixtures" do
  command "source #{node['gamification']['virtualenv']['location']}/bin/activate && paver install_dev_fixtures"
  cwd node['gamification']['location']
  action :nothing
  user 'root'
end

template "gamification_local_settings" do
  source "local_settings.py.erb"
  path "#{node['gamification']['virtualenv']['location']}/local_settings.py"
  variables ({:database => node['gamification']['settings']['DATABASES']['default']})
end

link "local_settings_symlink" do
  link_type :symbolic
  to "#{node['gamification']['virtualenv']['location']}/local_settings.py"
  target_file "#{node['gamification']['location']}/gamification/local_settings.py"
  not_if do File.exists?("#{node['gamification']['location']}/gamification/local_settings.py") end
end

hostsfile_entry node['gamification']['database']['address'] do
  hostname node['gamification']['database']['hostname']
  only_if do node['gamification']['database']['hostname'] && node['gamification']['database']['address'] end
  action :append
end

#include_recipe 'gamification::postgis'
include_recipe 'gamification::database'

directory node['gamification']['logging']['location'] do
  action :create
end

directory node['gamification']['settings']['static_root'] do
  owner "www-data"
  mode 00755
  action :create
  recursive true
end

directory "#{node['gamification']['settings']['static_root']}/CACHE" do
  owner "www-data"
  mode 00755
  action :create
  recursive true
end

directory "#{node['gamification']['settings']['static_root']}/CACHE/js" do
  owner "www-data"
  mode 00755
  action :create
  recursive true
end

directory "#{node['gamification']['settings']['static_root']}/CACHE/css" do
  owner "www-data"
  mode 00755
  action :create
  recursive true
end

bash "sync_db" do
  code "source #{node['gamification']['virtualenv']['location']}/bin/activate && paver sync"
  cwd "#{node['gamification']['location']}"
  action :nothing
end

execute "collect_static" do
  command "#{node['gamification']['virtualenv']['location']}/bin/python manage.py collectstatic --noinput"
  cwd "#{node['gamification']['location']}"
  action :nothing
end

bash "install_fixtures" do
  code "source #{node['gamification']['virtualenv']['location']}/bin/activate && paver delayed_fixtures"
  cwd "#{node['gamification']['location']}"
  user 'postgres'
  action :nothing
end

template "gamification_uwsgi_ini" do
  path "#{node['gamification']['virtualenv']['location']}/gamification.ini"
  source "gamification.ini.erb"
  action :create_if_missing
  notifies :run, "execute[start_django_server]"
end

include_recipe 'gamification::nginx'

start_gamification = "#{node['gamification']['virtualenv']['location']}/bin/uwsgi --ini #{node['gamification']['virtualenv']['location']}/gamification.ini &"

execute "start_django_server" do
  command start_gamification
end

file "/etc/cron.d/gamification_restart" do
  content "@reboot root #{node['gamification']['virtualenv']['location']}/bin/uwsgi --ini #{node['gamification']['virtualenv']['location']}/gamification.ini &"
  mode 00755
  action :create_if_missing
end
