# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

begin
  require "pry"
rescue LoadError
end

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

class RoutingTest < ActiveSupport::TestCase
  include ActionDispatch::Assertions::RoutingAssertions

  setup :default_route_settings

  private

  def default_route_settings
    RoutesJS::Routes.default_format = nil
    RoutesJS::Routes.include_patterns = nil
    RoutesJS::Routes.exclude_patterns = nil
  end
end
