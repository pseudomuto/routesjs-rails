module RoutesJS
  class Routes
    class << self
      attr_accessor :default_format, :include_patterns, :exclude_patterns

      def as_json(routes = nil)
        routes ||= ::Rails.application.routes.named_routes.routes
        js_routes = build_routes(routes)

        results = { routes: js_routes }
        results[:format] = default_format unless default_format.blank?
        results.as_json
      end

      def exclude_patterns
        @exclude_patterns ||= [/^rails/]
      end

      private

      def build_routes(routes)
        route_map = routes.values.inject({}) do |result, route|
          derived_route = RoutesJS::Routing::Route.new(route)
          result[derived_route.name] = derived_route.url if include_route?(derived_route)
          result
        end
      end

      def include_route?(route)
        name = route.name
        include?(name) && !exclude?(name)
      end

      def include?(name)
        include_patterns.nil? || Array(include_patterns).any? { |regex| name =~ regex }
      end

      def exclude?(name)
        exclude_patterns.present? && Array(exclude_patterns).any? { |regex| name =~ regex }
      end
    end
  end
end
