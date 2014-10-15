# Options (all default to nil)
#   default_format: Used to set a default format for all routes
#   only: An array of route names to be included (all others are excluded)
#   except: An array of routes to be excluded (all other routes are included)

# EXAMPLES
# RoutesJS::Routes.init(default_format: :json)
# RoutesJS::Routes.init(only: [:root, :new_user])
# RoutesJS::Routes.init(except: [:root, :some_route])

RoutesJS::Routes.init
