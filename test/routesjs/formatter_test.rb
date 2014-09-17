require "test_helper"

class RoutesJS::FormatterTest < ActiveSupport::TestCase
  include ActionDispatch::Assertions::RoutingAssertions

  setup do
    inspector.format(formatter)
  end

  test "only named routes are included" do
    assert_equal formatter.routes.keys.size, test_routes.size - 1
  end

  test "hand coded URLs are left as is" do
    assert_equal "/admin", formatter.routes["admin"]
  end

  test "namespaced routes include the namespace in the route" do
    assert_equal "/api/users", formatter.routes["apiUsers"]
  end

  test "named redirects are supported" do
    assert_equal "https://google.com/", formatter.routes["google"]
  end

  test "named redirects within a namespace are supported" do
    assert_equal "/", formatter.routes["apiHome"]
  end

  test "result is a valid JSON object" do
    assert_nothing_raised do
      JSON.parse(formatter.result)
    end
  end

  private

  def inspector
    @inspector ||= begin
      ActionDispatch::Routing::RoutesInspector.new(test_routes)
    end
  end

  def formatter
    @formatter ||= RoutesJS::Formatter.new
  end

  def test_routes
    @test_routes ||= with_routing do |set|
      set.draw do
        get "/", to: "home#index"
        get "/admin", to: "home#admin", as: :admin

        get "/google", to: redirect("https://google.com/"), as: :google

        namespace :api do
          get "/redir", to: redirect("/"), as: :home
          resources :users, only: [:index, :show]
        end
      end

      set.routes
    end
  end
end
