module RoutesJS
  class Routes
    def self.as_json(routes = nil)
      routes ||= ::Rails.application.routes.routes
      inspector = ActionDispatch::Routing::RoutesInspector.new(routes)
      inspector.format(Formatter.new)
    end
  end
end
