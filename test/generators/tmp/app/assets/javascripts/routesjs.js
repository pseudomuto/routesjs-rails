var Routes = (function(railsRoutes) {
  var BASE_URL = document.location.protocol +"//" + document.location.host;
  var PARAM_PATTERN = /:[^\/$]+(\/|$)/

  var isUrl = function(path) {
    return /^https?:\/\//.test(path);
  };

  var addRoute = function(name, path) {
    RouteSet[name +"Path"] = function() {
      return buildRoute(path, arguments);
    };

    RouteSet[name +"Url"] = function() {
      var finalPath = path;
      if (!isUrl(path)) finalPath = BASE_URL + path;

      return buildRoute(finalPath, arguments);
    };
  };

  var buildRoute = function(route, args) {
    if (!(args && args.length)) return route;
    if (!PARAM_PATTERN.test(route)) return route;

    if(args.length === 1 && args[0] instanceof Object) {
      return buildRouteWithObject(route, args[0]);
    } else {
      return buildRouteWithValues(route, args);
    }
  };

  var buildRouteWithObject = function(route, fromObject) {
    var token = null, key = null;
    var tokens = Object.keys(fromObject);

    for (var i = 0; i < tokens.length; i++) {
      key = tokens[i];
      token = fromObject[key].toString();
      route = route.replace(RegExp(":" + key.toString()), token);
    }

    return route;
  };

  var buildRouteWithValues = function(route, values) {
    var param = null;

    while (PARAM_PATTERN.test(route) &&  values.length) {
      param = [].shift.call(values).toString();
      route = route.replace(PARAM_PATTERN, param + "$1");
    }

    return route;
  };

  var RouteSet = {
    setBaseUrl: function(protocol_and_host) {
      BASE_URL = protocol_and_host.replace(/\/$/, "");
    },
    initRoutes: function(routes) {
      Object.keys(routes).map(function(key) {
        addRoute(key, routes[key]);
      });
    }
  };

  RouteSet.initRoutes(railsRoutes);
  return RouteSet;
})({"teaspoon":"/teaspoon","root":"/","adminGoogle":"https://www.google.com/","rolesAdminUser":"/admin/users/:id/roles","adminUsers":"/admin/users","newAdminUser":"/admin/users/new","editAdminUser":"/admin/users/:id/edit","adminUser":"/admin/users/:id"});

if (typeof(module) !== 'undefined') {
  module.exports = Routes;
}
;
