source 'https://rubygems.org'

gem 'rails', '3.2.8'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3', :group => [:test, :development]
group :production do
  gem 'pg'
  gem 'thin'
  gem 'exception_notification', :require => 'exception_notifier', :git => 'git://github.com/alanjds/exception_notification.git'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'responders'
gem 'rails-i18n'
gem 'google-api-client', :require => 'google/api_client'
gem 'omniauth', '~> 1.0.0'
gem 'omniauth-google-oauth2'
gem 'enumerated_attribute'
gem 'devise'
gem 'devise-i18n'
gem 'rails_admin'
gem 'cancan'
gem 'dalli'

#gem "twitter-bootstrap-rails"
gem "twitter-bootstrap-rails", :git => "git://github.com/scriptwork/twitter-bootstrap-rails.git"

group :development, :test do
  gem 'rspec-rails'
  gem 'webrat'
  gem 'spork'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
