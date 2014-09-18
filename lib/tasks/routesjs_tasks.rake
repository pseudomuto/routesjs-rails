require "routesjs-rails"

namespace :routesjs do
  desc "generate a json representation of your routes"
  task generate: :environment do
    json = RoutesJS::Routes.as_json
    puts json
  end
end
