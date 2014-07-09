gem_package "pg" do
  action :install
end

postgresql_connection_info = {
  :host     => node['gamification']['database']['hostname'],
  :port     => node['gamification']['database']['port'],
  :username => 'postgres',
  :password => node['postgresql']['password']['postgres']
}

gamification_db = node['gamification']['settings']['DATABASES']['default']

# Create the gamification user
postgresql_database_user gamification_db[:user] do
    connection postgresql_connection_info
    password gamification_db[:password]
    action :create
end

# Create the gamification database
postgresql_database gamification_db[:name] do
  connection postgresql_connection_info
  template node['postgis']['template_name']
  owner gamification_db[:user]
  action :create
end

# postgresql_database 'set user' do
#   connection   postgresql_connection_info
#   database_name gamification_db[:name]
#   sql 'grant select on geometry_columns, spatial_ref_sys to ' + gamification_db[:user] + ';'
#   action :query
# end
