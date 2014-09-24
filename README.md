# routesjs-rails

[![Build Status](https://travis-ci.org/pseudomuto/routesjs-rails.svg?branch=master)](https://travis-ci.org/pseudomuto/routesjs-rails)
[![Gem Version](https://badge.fury.io/rb/routesjs-rails.svg)](https://rubygems.org/gems/routesjs-rails)
[![Code Climate](https://codeclimate.com/github/pseudomuto/routesjs-rails/badges/gpa.svg)](https://codeclimate.com/github/pseudomuto/routesjs-rails)

Make your Rails routes available in JS!

# Installation

* Just add `gem routesjs-rails` to your _Gemfile_ and run `bundle install`
* Add `//= require routesjs-rails` to your _application.js_ file.

# Usage

Requiring `routesjs-rails` will make a global object available called `Routes`. This object
will have two methods for every _named_ route in config/routes.rb; the path method and the url
method.

The _path_ version of the method will return the absolute path to the resource, while the _url_
version will return the full (including protocol, hostname, port, etc) URL to the resource.

```
// e.g.
Routes.userPath(1);
Routes.rootUrl();
```

Suppose we have the following in _config/routes.rb_:

```
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

```
{
  "root": "/",
  "google": "https://www.google.com/",
  "apiRoot": "/api",
  "apiUsers": "/api/users",
  "apiUser": "/api/users/:id"
}
```

This object will be passed to the Route object's initialization function, which will make the following
methods available (assuming you're running your site at `http://www.example.com/`):

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

For routes with parameters, you can pass the as simple arguments to the method or as an object that
responds to the parameter name (see `apiUsersPath` above for an example).

## Route Parameters

Parameters can be passed to a route using arguments to the path/url method. There are two ways to do
this, using argument values in the order they're supplied, or by passing an object that responds to
each route parameter name.

```
// route in rails: /users/:id/roles/:role_id
Routes.userRolePath(1, 2); // returns /users/1/roles/2
Routes.userRolePath({ id: 1, role_id: 2 }); // also returns /users/1/roles/2
```

# Using as a CommonJS Module

If you'd like to use your routes in a CommonJS module, you'll need to generate the module file by
running the following:

```
rails g routes_js:module
```

This will generator a JS module at _app/assets/javascripts/routejs.js_. If you'd like to change the
path you can supply the `-o` option.

```
rails g routes_js:module -o <full_path>
```
If you want to create a routes file manually, you can run `bundle exec rake routesjs:generate` which
will generate the full output of the routejs-rails javascript file (including your routes at the
bottom).

You can save this output to a file, or use it to inspect the generated result if necessary.
