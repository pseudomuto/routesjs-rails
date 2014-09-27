module RoutesJS
  class Routes
    class << self
      attr_accessor :default_format

      def as_json(routes = nil)
        routes ||= ::Rails.application.routes.routes
        js_routes = routes.inject({}) do |result, route|
          derived_route = RoutesJS::Routing::Route.new(route)
          result[derived_route.name] = derived_route.url if derived_route.valid?
          result
        end

        results = { routes: js_routes }
        results[:format] = default_format unless default_format.blank?
        results.as_json
      end
    end
  end
end
