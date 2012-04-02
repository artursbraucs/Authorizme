# Authorizme

Simple authorization plugin for Ruby on Rails applications that by default includes basic authorization and 3 provider authorization with Latvia social network draugiem.lv, facebook.com and twitter.com.

## Installation

Add to your Gemfile and run the `bundle` command to install it.

```ruby
gem "authorizme"
```

Run authorizme install generator from your app folder

```ruby
rails g authorizme:install
```

That will install:

* config file `authorizme.rb` in to `config/initializers`
* `User` model with `acts_as_authorizme` method
* migrations for authorizme

Then migrate your database `rake db:migrate`

**Requires Ruby 1.9.2 or later and Rails 3.2.1 or later.**

## Usage

### Getting started

To authorize user with basic authorization, post email and password to `/authorizme/sessions`. (if you have another namespace, use `/{your_namespace}/sessions`)

To authorize user with providers, use `/authorizme/login/{provider_name}`. Before that you MUST set your api keys and secrets to those providers in `config/initializers`

To register user with basic authorization you can just save data to your user model and then call `login(user)` from your controller.

### Advanced usage

You can implement your own provider. Create controller under model `Authorizme::Login` and extend `AuthorizmeController`. Then you must implement `auth` and `callback` methods, where `auth` is method which redirect user to provider and `callback` get data from provider callback data. Then you must add your provider namespace in authorizme config file in array `providers`. 

## Development

Questions or problems? Please post them on the [issue tracker](https://github.com/CreativeMobile/authorizme/issues). You can contribute changes by forking the project and submitting a pull request. You can ensure the tests passing by running `bundle` and `rake`.

This gem is created by Arturs Braucs @ Creative Mobile and is under the MIT License.