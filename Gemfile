source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
gem 'mongoid', '~> 6.1.0'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# API protection
gem 'rack-attack'

gem 'rack-cors'

# Service objects utils
gem 'immutable-struct'

# Handling http requests
gem 'httparty'

# Fast xml parser for parsing feed
gem 'ox'

# Documentation
gem 'rswag'

gem 'rubocop', require: false

group :development, :production do
  # Redis will be used for caching requests
  # It is not the best approach to cache all response,
  # but it should be OK for now
  gem 'redis'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'factory_bot_rails', '~> 4.0'
  gem 'pry'
end

group :test do
  gem 'database_cleaner'
  gem 'fakeredis'
  gem 'mongoid-rspec', github: 'mongoid-rspec/mongoid-rspec'
  gem 'rails-controller-testing'
  gem 'rspec'
  gem 'rspec-rails', '~> 3.6'
  gem 'shoulda-matchers'
  gem 'webmock'
end
