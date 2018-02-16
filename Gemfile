source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.13', '< 0.5'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem "kaminari"
gem 'resque'
gem 'omniauth-oauth2', '1.3.1'   
gem "omniauth-google-oauth2"
gem 'omniauth-linkedin-oauth2'
gem 'omniauth-facebook', '~> 4.0.0'     #fix for uri_mismatch after Facebook API Deprecation.  
gem 'paperclip'
gem 'aws-sdk', '2.10.42'     #specify this version to fix "NameError (uninitialized constant Aws::VERSION)"
# Use ActiveModel has_secure_password

#gem 'bcrypt', '~> 3.1.7'
gem 'bcrypt', git: 'https://github.com/codahale/bcrypt-ruby.git', :require => 'bcrypt'
gem 'roo', '~> 2.3', '>= 2.3.2'  #excel
gem 'roo-xls'
gem "custom_error_message" 
gem 'activerecord-import'
gem 'jquery-ui-rails'
gem 'rails4-autocomplete' 
#gem 'footable-rails'    #same as datatables but very responsive
gem 'newrelic_rpm'
gem 'activerecord-session_store'
gem 'wicked_pdf'  #pdf generation
gem 'wkhtmltopdf-binary'  #pdf generation essential for wicked_pdf gem
gem 'google-api-client', '~> 0.11'
gem 'googleauth' #used in server to server auth in GA
gem 'googlecharts'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'meta_request'   #for rails panel chrome add-on
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]


group :production do
  gem "puma"
  gem 'rails_12factor'
end