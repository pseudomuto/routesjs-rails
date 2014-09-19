# routesjs-rails

[![Build
Status](https://travis-ci.org/pseudomuto/routesjs-rails.svg?branch=master)](https://travis-ci.org/pseudomuto/routesjs-rails)

Make your Rails routes available in JS!

# Installation

Just add `gem routesjs-rails` to your _Gemfile_ and run `bundle install`

# Using with Sprockets

Add `//= require routesjs-rails` to your _application.js_ file.

# Generating Routes

If you want to create a routes file manually, you can run `bundle exec routesjs:generate` which will
show you a JSON version of your routes.

You can save this output to a file, or use it to inspect the generated result if necessary.
