module RoutesJS
  module Routing
    class Route
      attr_reader :name, :url, :options

      def initialize(rails_route, options = {})
        @name = generate_name(rails_route)
        @url = generate_url(rails_route)
        @options = options
      end

      def valid?
        return false if name.blank?
        include? && !exclude?
      end

      private

      def include?
        return true unless options[:include_patterns]
        match?(options[:include_patterns])
      end

      def exclude?
        return false unless options[:exclude_patterns]
        match?(options[:exclude_patterns])
      end

      def match?(patterns)
        Array(patterns).any? { |regex| name =~ regex }
      end

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
