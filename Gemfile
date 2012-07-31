source 'https://rubygems.org'

gem 'rails', '3.2.5'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'


  # gems specifically for Heroku go here
  gem 'mysql2', '~> 0.3.11'
  gem 'thin'
group :development do
  gem 'taps', :require => false # has an sqlite dependency, which heroku hates
end


 group :production do
  # gems specifically for Heroku go here
  # gem "pg"
  gem 'newrelic_rpm'
  ruby "1.9.3"
  gem 'taps'
end

gem 'json'
gem 'jquery-ui-rails'

gem 'less-rails-bootstrap'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'


end

gem 'jquery-rails'
gem 'shopify_app'
#test add
# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'
