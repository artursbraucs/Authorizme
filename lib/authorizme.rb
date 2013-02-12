# Requires
require "rails"
require "active_support/dependencies"
require "active_record"
require "action_controller"

require "authorizme/version"
require "oauth2"
require "fbgraph"
require "twitter_oauth"
require "twitter"

require 'authorizme/acts_as_authorizme'
require 'authorizme/for_controllers'

module Authorizme
  autoload :Provider, 'authorizme/provider'

  # Our host application root path
  # We set this when the engine is initialized
  mattr_accessor :app_root

  # Atributes for draugiem.lv API
  mattr_accessor :draugiem_app_id
  @@draugiem_app_id = "15008309"

  mattr_accessor :draugiem_app_key
  @@draugiem_app_key = "ae2f1dd28c28490e95480a74952d549b"

  mattr_accessor :draugiem_api_authorize_path
  @@draugiem_api_authorize_path = "http://api.draugiem.lv/authorize/"

  mattr_accessor :draugiem_api_path
  @@draugiem_api_path = "http://api.draugiem.lv/json/"

  # Atributes for facebook.com API
  mattr_accessor :facebook_client_id
  @@facebook_client_id = "340578915987797"

  mattr_accessor :facebook_client_secret
  @@facebook_client_secret = "6cfd9cf26dfbb6f299fd7ad0bb0ca08a"

  mattr_accessor :facebook_perms
  @@facebook_perms = "email,read_stream,offline_access"

  # Atributes for twitter.com API
  mattr_accessor :twitter_consumer_key
  @@twitter_consumer_key = "MStc9ncAw6gnwaJaRcg9ZA"

  mattr_accessor :twitter_consumer_secret
  @@twitter_consumer_secret = "XsrFZXWAyjUyc0WY5hGE32shg6YkhKjbadbHmJmTXM"

  mattr_accessor :after_login_path
  @@after_login_path = :root

  mattr_accessor :after_logout_path
  @@after_logout_path = :root
  
  mattr_accessor :namespace
  @@namespace = :authorizme
  
  mattr_accessor :not_logged_in_path
  @@not_logged_in_path = "/#{Authorizme::namespace}/"
  
  mattr_accessor :providers
  @@providers = ["draugiem", "facebook", "twitter"]
  
  # Yield self on setup for nice config blocks
  def self.setup
    yield self
  end
end

# Require our engine
require "authorizme/engine"