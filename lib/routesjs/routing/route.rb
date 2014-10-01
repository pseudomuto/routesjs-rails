module RoutesJS
  module Routing
    class Route
      attr_reader :name, :url

      def initialize(rails_route)
        @name = generate_name(rails_route)
        @url = generate_url(rails_route)
      end

      def valid?
        !(name.blank? || /^rails/.match(name))
      end

      private

      def generate_name(route)
        route.name.try(:camelize, :lower)
      end

      def generate_url(route)
        return redirect_url(route) if redirect?(route)
        route.path.spec.to_s.sub(/\(\.:format\)\z/, "")
      end

      def redirect_url(route)
        app(route).block
      end

      def redirect?(route)
        app(route).respond_to?(:block)
      end

      def app(route)
        route.app.respond_to?(:app) ? route.app.app : route.app
      end
    end
  end
end
