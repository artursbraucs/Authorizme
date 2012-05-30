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

#### Authorization

To authorize user with basic authorization, post email and password to `/authorizme/sessions`. (if you have another namespace, use `/{your_namespace}/sessions`)

To authorize user with providers, use `/authorizme/login/{provider_name}`. Before that you MUST set your api keys and secrets to those providers in `config/initializers`

To register user with basic authorization you can just save data to your user model and then call `login(user)` from your controller.

#### Using roles

Also you can set roles. Just add some roles in Role model and then set it to user. In controller you can use `before_filter` method `require_user` or `require_{role}` where `role` is your required role name. 

### Advanced usage

#### Synchronize

You can sync your accounts. If user login with another provider on existing user session, then plugin will set synchronize request. You can call `has_synchronize_request?` and check if there's any new request. Then you can call 'synchronize(user)' to user model. 

Also you can use synchronize without requests (synchronous synchronize). Just add get param `synchronize=true` in login url (e.c. /authorizme/login/twitter?synchronize=true).

#### Custom provider callback view

By default providers use callback view which require JQuery and require `eventBus` in `window` dom element:

```javascript
<script type="text/javascript">
  $(document).ready(function() {
    window.close();
    window.opener.eventBus.trigger("loginDone");
    window.opener.focus();
  });
</script>
```
You can override this by creating new view: `views/authorizme/authorizme/popup.html.erb`.

#### Custom providers

You can implement your own provider: 

1. Create controller under model `Authorizme::Login` and extend `AuthorizmeController`. 
2. You must implement `auth` and `callback` methods, where `auth` is method which redirect user to provider and `callback` get data from provider callback data. 
3. Then you must add your provider namespace in authorizme config file in array `providers`. 

## Development

Questions or problems? Please post them on the [issue tracker](https://github.com/CreativeMobile/authorizme/issues). You can contribute changes by forking the project and submitting a pull request. You can ensure the tests passing by running `bundle` and `rake`.

This gem is created by Arturs Braucs @ Creative Mobile and is under the MIT License.