# Requires
require "rails"
require "active_support/dependencies"
require "active_record"

require "authorizme/version"


module Authorizme
  autoload :AuthorizmeRecord, 'authorizme/authorizme_record'
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
  @@facebook_client_id = ""

  mattr_accessor :facebook_client_secret
  @@facebook_client_secret = ""

  mattr_accessor :facebook_perms
  @@facebook_perms = "read_stream"

  # Atributes for twitter.com API
  mattr_accessor :twitter_consumer_key
  @@twitter_consumer_key = ""

  mattr_accessor :twitter_consumer_secret
  @@twitter_consumer_secret = ""

  mattr_accessor :after_login_path
  @@after_login_path = ""

  mattr_accessor :after_logout_path
  @@after_logout_path = ""

  mattr_accessor :namespace
  @@namespace = :authorizme

  mattr_accessor :remote
  @@remote = false
  
  # Yield self on setup for nice config blocks
  def self.setup
    yield self
  end
end

# Require our engine
require "authorizme/engine"