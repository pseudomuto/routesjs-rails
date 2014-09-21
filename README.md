# routesjs-rails

[![Build
Status](https://travis-ci.org/pseudomuto/routesjs-rails.svg?branch=master)](https://travis-ci.org/pseudomuto/routesjs-rails)

Make your Rails routes available in JS!

# Installation

* Just add `gem routesjs-rails` to your _Gemfile_ and run `bundle install`
* Add `//= require routesjs-rails` to your _application.js_ file.

# Usage

Including the routesjs-rails script will make a global object available called `Routes`. This object
will have two methods for every _named_ routes in config/routes.rb; the path method and the url
method.

The _path_ version of the method will return the absolute path to the resource, while the _url_
version will return the full (including protocol, hostname, port, etc) URL to the resource.

## For Example

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

This object will be passed to the Route object's `initRoutes` method, which will make the following
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
`Routes.apiUserPath(1)` | `/api/users/1`
`Routes.apiUserPath({ id: 1 })` | `/api/users/1`
`Routes.apiUserUrl(1)` | `http://www.example.com/api/users/1`
`Routes.apiUserUrl({ id: 1 })` | `http://www.example.com/api/users/1`

For routes with parameters, you can pass the as simple arguments to the method or as an object that
responds to the parameter name (see `apiUsersPath` above for an example).

# Generating Routes

If you want to create a routes file manually, you can run `bundle exec routesjs:generate` which will
show you a JSON version of your routes.

You can save this output to a file, or use it to inspect the generated result if necessary.
