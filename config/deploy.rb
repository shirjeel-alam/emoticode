set :application, 'emoticode'
set :user, 'root'
set :repo_url, 'git@github.com:shirjeel-alam/emoticode.git'

# Default value for :scm is :git
set :scm, :git

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/secrets.yml config/newrelic.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/avatars}

set :ssh_options, {
  forward_agent: true
}

namespace :memcached do
  desc "Flushes memcached local instance"
  task :flush do
    on roles(:app) do
      execute "cd #{current_path}; RAILS_ENV=#{fetch(:rails_env).to_s} rake memcached:flush"
    end
  end
end

namespace :deploy do
  after :updated, 'memcached:flush'
  after :finishing, 'deploy:cleanup'
end