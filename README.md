# routesjs-rails

[![Build Status](https://travis-ci.org/pseudomuto/routesjs-rails.svg?branch=master)](https://travis-ci.org/pseudomuto/routesjs-rails)
[![Gem Version](https://badge.fury.io/rb/routesjs-rails.svg)](https://rubygems.org/gems/routesjs-rails)
[![Code Climate](https://codeclimate.com/github/pseudomuto/routesjs-rails/badges/gpa.svg)](https://codeclimate.com/github/pseudomuto/routesjs-rails)

Make your Rails routes available in JS!

**Supports Ruby 1.9.3+ and Rails 4.0+**

# Installation

* Add `gem routesjs-rails` to your _Gemfile_ and run `bundle install`
* Run `rails g routes_js:install`
* Add `//= require routesjs-rails` to your _application.js_ file.

# Usage

Requiring `routesjs-rails` in your JS manifest, will create a global object called `Routes`. This object
will have two methods for every _named_ route in config/routes.rb; the path method and the url
method.

The _path_ version of the method will return the absolute path to the resource, while the _url_
version will return the full (including protocol, hostname, port, etc) URL to the resource.

```javascript
// e.g.
Routes.userPath(1);
Routes.rootUrl();
```

Suppose we have the following in _config/routes.rb_:

```ruby
Rails.application.routes.draw do
  root: "home#index"
  get "/google", to: redirect("https://www.google.com/"), as: :google

  namespace :api do
    root "api#index"
    resources :users, only: [:index, :show]
  end
end
```

We would end up with the following routes being defined:

Method | Result
------ | ------
`Routes.rootPath()` | `/`
`Routes.rootUrl()` | `http://www.example.com/`
`Routes.googlePath()` | `https://www.google.com/`
`Routes.googleUrl()` | `https://www.google.com/`
`Routes.apiRootPath()` | `/api`
`Routes.apiRootUrl()` | `http://www.example.com/api`
`Routes.apiUsersPath()` | `/api/users`
`Routes.apiUsersUrl()` | `http://www.example.com/api/users`
`Routes.apiUserPath()` | `/api/users/:id`
`Routes.apiUserUrl()` | `http://www.example.com/api/users/:id`

## Route Parameters

Parameters can be passed to a route using arguments to the path/url method. There are two ways to do
this, using argument values in the order they're supplied, or by passing an object that responds to
each route parameter name.

```javascript
// route in rails: /users/:id/roles/:role_id
Routes.userRolePath(1, 2); // returns /users/1/roles/2
Routes.userRolePath({ id: 1, role_id: 2 }); // also returns /users/1/roles/2
```

## Route Formats

You can generate format (json, html, etc) routes by passing an object with a format property. For
example:

`Routes.userRolePath({ id: 1, role_id: 2, format: "json" }) // returns /users/1/roles/2.json`

You can also call the `json(), html(), xml() and none()` methods on routes. Doing so will override 
the default and object supplied formats. For example:

```javascript
// assuming .html is the default format in config/initializers/routesjs-rails.rb
apiUsersPath(1) // returns /api/users/1.html
apiUsersPath({ id: 1, format: "xml" }) // returns /api/users/1.xml
apiUsersPath({ id: 1, format: "xml" }).json() // returns /api/users/1.json
apiUsersPath(1).none() // returns /api/users/1
```

### Setting a Global Default

The default format can be set by suppliying a `:default_format` option in the initializer.

```
# config/initializers/routesjs-rails.rb
RoutesJS::Routes.init(default_format: :json)
```

Formats specified on the object will override the default format.

# Choosing Which Routes to Include

Routes can be selectively included/excluded by passing an array of routes to either `:only` or
`:except` in the initializer.

For example:

```
# in config/initializers/routesjs-rails.rb

# include routes using only
RoutesJS::Routes.init(only: [:root, :new_user])

# or to exclude routes using except
# RoutesJS::Routes.init(except: :root)
```

# Using as a CommonJS Module

If you'd like to use your routes in a CommonJS module, you'll need to generate the module file by
running the following (`-o` parameter is optional):

```
rails g routes_js:module [-o <full_path>]
```

By default, this will generate a JS module at _app/assets/javascripts/routejs.js_. If you've
specified the `-o` option, the file will be placed where you specified. 

Now you can use your module by requiring it: `var Routes = require("routesjs")`
