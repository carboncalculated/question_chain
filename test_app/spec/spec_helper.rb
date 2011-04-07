ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
require File.expand_path("../factories", __FILE__)

require "database_cleaner"
DatabaseCleaner[:mongoid].strategy = :truncation
DatabaseCleaner.clean_with(:truncation)

Rspec.configure do |config|
   config.before(:suite) do
     DatabaseCleaner.start
   end

   config.after(:each) do
     DatabaseCleaner.clean
   end
   
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
  config.mock_with :rspec
end