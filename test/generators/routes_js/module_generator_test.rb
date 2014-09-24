require "test_helper"
require "generators/routes_js/module/module_generator"

module Generators
  module RoutesJs
    class ModuleGeneratorTest < Rails::Generators::TestCase
      tests ::RoutesJs::Generators::ModuleGenerator
      destination File.expand_path("../tmp", File.dirname(__FILE__))

      setup do
        prepare_destination
      end

      test "generates the CommonJS module" do
        run_generator
        assert_file "app/assets/javascripts/routesjs.js"
      end

      test "overwites the existing module if found" do
        run_generator

        assert_nothing_raised do
          run_generator
        end
      end

      test "can output to a user specified path" do
        run_generator %w(-o app/assets/javascripts/config/routes.js)

        assert_no_file "app/assets/javascripts/routesjs.js"
        assert_file "app/assets/javascripts/config/routes.js"
      end
    end
  end
end
