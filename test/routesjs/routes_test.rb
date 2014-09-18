require "test_helper"

class RoutesJS::RoutesTest < ActiveSupport::TestCase
  include ActionDispatch::Assertions::RoutingAssertions

  test "routes are rendered as a valid json object" do
    with_routing do |set|
      set.draw do
        resources :users
      end

      assert_nothing_raised do
        JSON.parse(RoutesJS::Routes.as_json(set.routes))
      end
    end
  end
end
