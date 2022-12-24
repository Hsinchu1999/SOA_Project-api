# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

# Presentation layer
gem 'multi_json'
gem 'roar'

# Web Application
gem 'figaro', '~> 1.2'
gem 'puma', '~> 5'
gem 'rack-session', '~> 0.3'
gem 'roda', '~> 3'
gem 'redis'
gem 'rack-cache'
gem 'redis-rack-cache'

gem 'rake'

# Database
gem 'hirb', '~> 0'
gem 'hirb-unicode', '~> 0'
gem 'sequel', '~> 5.49'
group :development, :test do
  gem 'sqlite3'
end
group :production do
  gem 'pg'
end

# Networking
gem 'http', '~> 5'

# Testing
gem 'minitest', '~> 5.0'
gem 'minitest-rg', '~> 5'
gem 'rack-test', '~> 2.0.2'
gem 'simplecov', '~> 0'
gem 'vcr', '~> 6'
gem 'webmock', '~> 3'

# Code Quality
gem 'reek'

# Entities
gem 'dry-struct', '~> 1'
gem 'dry-types', '~> 1'

# Controllers and services
gem 'dry-monads', '~> 1.4'
gem 'dry-transaction', '~> 0.13'
gem 'dry-validation', '~> 1.7'

# Debugging
gem 'pry'
