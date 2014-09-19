module RoutesJS
  class Routes
    def self.as_json(routes = nil)
      routes ||= ::Rails.application.routes.routes
      js_routes = routes.inject({}) do |result, route|
        derived_route = RoutesJS::Routing::Route.new(route)
        result[derived_route.name] = derived_route.url if derived_route.valid?
        result
      end

      js_routes.to_json
    end
  end
end
