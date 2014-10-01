require "rails/generators"

module RoutesJs
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      desc "Performs installation of routesjs initializer"
      source_root File.expand_path("../templates", __FILE__)

      def create_initializer
        copy_file "routesjs_rails.rb", "config/initializers/routesjs_rails.rb"
      end
    end
  end
end
