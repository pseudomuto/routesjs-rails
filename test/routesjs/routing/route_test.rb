require "test_helper"

class RoutesJS::Routing::RouteTest < ActiveSupport::TestCase
  include ActionDispatch::Assertions::RoutingAssertions

  test "hand crafted URLs are left untouched" do
    assert_equal "/admin", routes["admin"]
  end

  test "namespaced routes include the namespace in the path" do
    assert_equal "/api/users", routes["apiUsers"]
  end

  test "redirects return the redirect path" do
    assert_equal "https://www.google.com/", routes["google"]
  end

  test "redirects within a namespace are all good" do
    assert_equal "/", routes["apiRedir"]
  end

  test "root route is supported" do
    assert_equal "/", routes["root"]
  end

  test "root route inside a namespace also good" do
    assert_equal "/api", routes["apiRoot"]
  end

  test "routes that start with /rails are excluded" do
    routes.each do |key, value|
      refute key =~ /\Arails/
    end
  end

  private

  def routes
    @routes ||= JSON.parse(RoutesJS::Routes.as_json(app_routes))
  end

  def app_routes
    @app_routes ||= begin
      with_routing do |set|
        set.draw do
          root to: "home#index"
          get "/admin", to: "home#index", as: :admin
          get "/google", to: redirect("https://www.google.com/"), as: :google
          get "/rails/props", to: "home#index", as: :rails_props

          namespace :api do
            root to: "api#index"
            get "/redir", to: redirect("/"), as: :redir
            resources :users, only: [:index, :show]
          end
        end

        set.routes
      end
    end
  end
end
