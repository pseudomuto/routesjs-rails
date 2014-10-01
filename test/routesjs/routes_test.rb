require "test_helper"

class RoutesJS::RoutesTest < ActiveSupport::TestCase
  include ActionDispatch::Assertions::RoutingAssertions

  setup do
    RoutesJS::Routes.default_format = nil
  end

  test "routes are rendered as part of json object" do
    assert config.has_key?("routes")
  end

  test "when not specified, default format is not part of the json object" do
    refute config.has_key?("format")
  end

  test "when specified, default format is part of the json object" do
    RoutesJS::Routes.default_format = "json"
    assert config.has_key?("format")
  end

  private

  def config
    @config ||= RoutesJS::Routes.as_json(routes)
  end

  def routes
    @routes ||= with_routing do |set|
      set.draw { resources :users }
      set.routes
    end
  end
end
