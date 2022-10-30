source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'active_storage_validations', '0.9.7'
gem 'bcrypt',                     '3.1.16'
gem 'bootsnap',                   '1.11.1', require: false
gem 'bootstrap-sass',             '3.4.1'
gem 'bootstrap-will_paginate',    '1.0.0'
gem 'faker',                      '2.20.0'
gem 'image_processing',           '1.12.2'
gem 'importmap-rails',            '1.0.3'
gem 'jbuilder',                   '2.11.5'
gem 'puma',                       '5.6.4'
gem 'rails',                      '7.0.3'
gem 'sassc-rails',                '2.1.2'
gem 'sprockets-rails',            '3.4.2'
gem 'stimulus-rails',             '1.0.4'
gem 'turbo-rails',                '1.0.1'
gem 'will_paginate',              '3.3.1'
gem "faker", "2.20.0"
gem "activesupport"
gem "carrierwave"
gem "fog-aws"
gem "twitter"
gem "twitter_api"
gem "whenever"
gem "rails-i18n"
group :development do
  gem "dotenv-rails"
end


group :development do
  gem 'debug',   '1.4.0', platforms: %i[mri mingw x64_mingw]
  gem 'rubocop'
  gem 'solargraph'
  gem 'sqlite3', '1.4.2'
end

group :development do
  gem 'web-console', '4.2.0'
end

group :test do
  gem 'capybara',                 '3.36.0'
  gem 'guard',                    '2.18.0'
  gem 'guard-minitest',           '2.4.6'
  gem 'minitest',                 '5.15.0'
  gem 'minitest-reporters',       '1.5.0'
  gem 'rails-controller-testing', '1.0.5'
  gem 'selenium-webdriver',       '4.1.0'
  gem 'webdrivers',               '5.0.0'
end

group :production,:test do
  gem 'aws-sdk-s3', '1.113.0', require: false
  gem 'pg',         '1.3.3'
end
