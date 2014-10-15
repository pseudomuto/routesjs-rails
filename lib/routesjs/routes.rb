module RoutesJS
  class Routes
    class << self
      attr_accessor :default_format, :named_routes, :filter_type

      def init(options = {})
        reset

        set_format_from_options(options)
        make_filter(options, :except) if options.has_key?(:except)
        make_filter(options, :only) if options.has_key?(:only)
      end

      def as_json(routes = nil)
        routes ||= ::Rails.application.routes.named_routes.routes
        js_routes = build_routes(routes)

        results = { routes: js_routes }
        results[:format] = default_format unless default_format.blank?
        results.as_json
      end

      private

      def reset
        self.default_format = nil
        self.named_routes = nil
        self.filter_type = nil
      end

      def set_format_from_options(options)
        self.default_format = options[:default_format]
      end

      def make_filter(options, type)
        self.filter_type = type
        self.named_routes = Array(options[type]).map(&:to_s)
      end

      def build_routes(routes)
        route_map = routes.values.inject({}) do |result, route|
          if include_route?(route)
            derived_route = RoutesJS::Routing::Route.new(route)
            result[derived_route.name] = derived_route.url
          end

          result
        end
      end

      def include_route?(route)
        return true unless named_routes.present? && named_routes.any?

        found = named_routes.include?(route.name)
        filter_type == :only ? found : !found
      end
    end
  end
end
