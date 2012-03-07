module Authorizme
  class UserRole < ActiveRecord::Base
  	has_many :users
  end
end