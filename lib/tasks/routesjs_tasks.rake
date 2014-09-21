require "routesjs-rails"

namespace :routesjs do
  desc "generate a json representation of your routes"
  task generate: :environment do
    puts Rails.application.assets["routesjs-rails"].to_s
  end
end
