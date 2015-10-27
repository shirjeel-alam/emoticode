set :application, 'emoticode'
set :user, 'root'
set :repo_url, 'git@github.com:shirjeel-alam/emoticode.git'

# Default value for :scm is :git
set :scm, :git

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/secrets.yml config/newrelic.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :ssh_options, {
  forward_agent: true
}

namespace :deploy do
  after :finishing, 'deploy:cleanup'
end