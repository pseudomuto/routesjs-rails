# routesjs-rails

This project rocks and uses MIT-LICENSE.

# Installation

Just add `gem routesjs-rails` to your _Gemfile_ and run `bundle install`

# Using with Sprockets

Add `//= require routesjs-rails` to your _application.js_ file.

># Using as a CommonJS Module

>If you happen to be using some kind of CommonJS framework to manage your Js, you can require
>routesjs as a module like this `require("routesjs")`.

# Generating Routes

If you want to create a routes file manually, you can run `bundle exec routesjs:generate` which will
show you a JSON version of your routes.

You can save this output to a file, or use it to inspect the generated result if necessary.
