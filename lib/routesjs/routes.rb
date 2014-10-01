module RoutesJS
  class Routes
    class << self
      attr_accessor :default_format, :include_patterns, :exclude_patterns

      def as_json(routes = nil)
        routes ||= ::Rails.application.routes.routes
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
        routes.inject({}) do |result, route|
          derived_route = RoutesJS::Routing::Route.new(
            route,
            include_patterns: include_patterns,
            exclude_patterns: exclude_patterns
          )

          result[derived_route.name] = derived_route.url if derived_route.valid?
          result
        end
      end
    end
  end
end
