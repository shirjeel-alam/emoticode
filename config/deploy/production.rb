set :stage, :production
set :branch, 'master'

server '62.141.44.98', user: fetch(:user), roles: %w{web app db}, primary: true
set :deploy_to, "/var/www/#{fetch(:application)}"
set :rails_env, :production