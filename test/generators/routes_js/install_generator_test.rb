require "test_helper"
require "generators/routes_js/install/install_generator"

module Generators
  module RoutesJs
    class InstallGeneratorTest < Rails::Generators::TestCase
      tests ::RoutesJs::Generators::InstallGenerator
      destination File.expand_path("../tmp", File.dirname(__FILE__))

      setup do
        prepare_destination
      end

      test "generates the initializer" do
        run_generator
        assert_file "config/initializers/routesjs_rails.rb"
      end
    end
  end
end
