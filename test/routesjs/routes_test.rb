require "test_helper"

class RoutesJS::RoutesTest < RoutingTest

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

  test "non-named routes are not included" do
    refute_includes config["routes"].values, "/path"
  end

  test "when specified include patterns filter by name" do
    RoutesJS::Routes.include_patterns = [/root/, /new/]
    expected_paths = ["/", "/included/users/new", "/excluded/admins/new" ]

    assert_equal expected_paths.size, config["routes"].size
    expected_paths.each { |path| assert_includes config["routes"].values, path }
  end

  test "when specified, exclude patterns filter by name" do
    RoutesJS::Routes.exclude_patterns = [/excluded/i]
    config["routes"].values.each { |route| refute_match /excluded/i, route }
  end

  private

  def config
    @config ||= RoutesJS::Routes.as_json(routes)
  end

  def routes
    @routes ||= with_routing do |set|
      set.draw do
        root "dashboard#index"
        get "/path", to: redirect("/") # won't be named
        get "/google", to: redirect("https://www.google.com/"), as: :google

        namespace :included do
          resources :users
        end

        namespace :excluded do
          resources :admins
        end
      end

      set.named_routes.routes
    end
  end
end
