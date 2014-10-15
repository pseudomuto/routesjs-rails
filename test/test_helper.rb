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

  setup :init_routesjs

  private

  def init_routesjs
    RoutesJS::Routes.init
  end
end
