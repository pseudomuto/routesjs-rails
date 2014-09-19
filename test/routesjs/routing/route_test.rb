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

  private

  def routes
    @routes ||= JSON.parse(RoutesJS::Routes.as_json(app_routes))
  end

  def app_routes
    @app_routes ||= begin
      with_routing do |set|
        set.draw do
          get "/admin", to: "home#index", as: :admin
          get "/google", to: redirect("https://www.google.com/"), as: :google

          namespace :api do
            get "/redir", to: redirect("/"), as: :redir
            resources :users, only: [:index, :show]
          end
        end

        set.routes
      end
    end
  end
end
