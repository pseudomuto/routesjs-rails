# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

begin
  require "pry"
rescue LoadError
end

Rails.backtrace_cleaner.remove_silencers!
