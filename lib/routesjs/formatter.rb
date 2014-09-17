module RoutesJS
  class Formatter
    REDIRECT_URL = /\Aredirect\(\d+,([^)]+)\)\z/.freeze

    def routes
      @routes ||= {}
    end

    def result
      routes.to_json
    end

    def no_routes; end
    def header(routes); end
    def section_title(title); end

    def section(routes_in_section)
      named_routes(routes_in_section).each do |route|
        routes[route_name(route)] = route_path(route)
      end
    end

    private

    def named_routes(routes)
      routes.reject { |route| route[:name].blank? }
    end

    def route_name(route)
      route[:name].camelize(:lower)
    end

    def route_path(route)
      case
      when redirect?(route)
        redirect_url(route)
      else
        path_without_format(route)
      end
    end

    def redirect?(route)
      REDIRECT_URL =~ route[:reqs]
    end

    def redirect_url(route)
      REDIRECT_URL.match(route[:reqs])[1].strip
    end

    def path_without_format(route)
      route[:path].sub(/\(\.:format\)\z/, "")
    end
  end
end
