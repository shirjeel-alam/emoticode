source 'https://rubygems.org'

gem 'rails', '4.2.4'
gem 'mysql2', '0.3.20'                                            # mysql adapter
gem 'sass-rails'                                                  # scss
gem 'uglifier'                                                    # uglify js in production
gem 'coffee-rails'                                                # coffee-script
gem 'jquery-rails'                                                # jquery
gem 'jbuilder'                                                    # json api
gem 'albino'                                                      # syntax highlight
gem 'nokogiri'                                                    # syntax -> html
gem 'will_paginate'                                               # pagination
gem 'whenever', require: false                                    # cron jobs with ease
gem 'thinking-sphinx'                                             # sphinx library
gem 'charon'                                                      # check for spammers
gem 'htmlentities'
gem 'rabl'
gem 'impressionist'
gem 'redcarpet'
gem 'query_diet'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'responders'

gem 'omniauth'                                                    # social auth
gem 'omniauth-facebook'                                           # facebook connect
gem 'omniauth-github'                                             # github connect

gem 'dalli', '2.6.4'                                              # memcache client
gem 'dalli-delete-matched'
gem 'newrelic_rpm'                                                # new relic

gem 'devise'
gem 'activeadmin', '1.0.0.pre2'                                   # admin interface
gem 'simple_similarity'

gem 'sendgrid-rails'

# social features
gem 'koala', '~> 2.2'
gem 'twitter', '~> 4.8.1'

group :development do
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'letter_opener'

  # deploy
  gem 'capistrano-rails'
  gem 'capistrano-rails-db'
  gem 'capistrano-passenger'
  gem 'capistrano-safe-deploy-to'
  gem 'capistrano-memcached'
  gem 'capistrano-rails-console'
end

group :development, :test do
  gem 'annotate'
  gem 'pry-rails'
  gem 'puma'
end

# google analytics api OUTDATED. Use Legato (https://github.com/tpitale/legato)
# gem 'garb', git: 'git://github.com/Sija/garb.git'

# gem 'roadie' UNUSED GEM. If put back use 2.4.2

# gem 'fastimage_resize'                                            # avatar resizing
gem 'mini_magick'