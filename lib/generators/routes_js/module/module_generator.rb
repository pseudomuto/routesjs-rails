require "rails/generators"

module RoutesJs
  module Generators
    class ModuleGenerator < ::Rails::Generators::Base
      desc "Generates a CommonJS module based on the current Rails routes"
      source_root File.expand_path("../", __FILE__)

      class_option :output_file,
        type: :string,
        aliases: "-o",
        default: "app/assets/javascripts/routesjs.js"

      def generate_routes_module
        js_module = rails_application.assets["routesjs-rails"].to_s
        create_file(options[:output_file], js_module)
      end

      def show_post_install
        readme_message if behavior == :invoke
      end

      private

      def rails_application
        ::Rails::Application.subclasses.map(&:instance).first
      end

      def readme_message
        log "+============================================================================+"
        log "RoutesJS module was successfully generated. You can find it at:"
        log options[:output_file]
      end
    end
  end
end
