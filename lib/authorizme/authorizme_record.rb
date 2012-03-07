module Authorizme
  class AuthorizmeRecord < ActiveRecord::Base
    self.abstract_class = true
    
    # Relations
    belongs_to :role, :class_name => "Authorizme::UserRole"
    belongs_to :origin_provider, :class_name => "Authorizme::UserProvider"
    has_many :providers, :class_name => "Authorizme::UserProvider"

    # For authorization
    has_secure_password
    attr_accessible :email, :password, :password_confirmation
        
    # Validations
    validates_presence_of :password, :on => :create
    validates_presence_of :email
    validates_uniqueness_of :email
  end
end