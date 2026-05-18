source "https://rubygems.org"

ruby "3.3.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.6"

gem "haml-rails", "~> 2.1"
gem "html2haml", "~> 2.3"

gem "sassc-rails"
gem "bootstrap", "~> 5.3"

gem 'bcrypt', '~> 3.1.7'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails" 

# Use postgresql as the database for Active Record
gem "pg", "~> 1.5"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# jQuery (для Bootstrap)
gem "jquery-rails"

# Better Errors (отладка)
group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "better_errors"
  gem "binding_of_caller"
end

# Development только
group :development do
  gem "web-console"
  gem "error_highlight", ">= 0.4.0", platforms: [:ruby]
end

# Test только
group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

