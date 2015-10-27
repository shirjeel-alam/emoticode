# Load the Rails application.
require File.expand_path('../application', __FILE__)

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

ENV['INLINEDIR'] = Rails.root.join('tmp', 'cache').to_s  # for RubyInline

# Initialize the Rails application.
EmoticodeRails::Application.initialize!
