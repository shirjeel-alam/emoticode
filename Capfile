# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

require 'capistrano/bundler'
require 'capistrano/rails'
require 'capistrano/rails/db'
require 'capistrano/passenger'
require 'capistrano/safe_deploy_to'
require 'capistrano/memcached'
require 'capistrano/rails/console'

require 'whenever/capistrano'
require 'thinking_sphinx/capistrano'

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
