module Authorizme
  class UserProvider < ActiveRecord::Base
    #Relations
    belongs_to :user
    belongs_to :origin_user, :class_name => "User"

    #Validations
    # => Attributes
    validates :social_id, :presence => true
    validates :token, :presence => true

  end
end