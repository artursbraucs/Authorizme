module Authorizme
   class AuthorizmeRecord < ActiveRecord::Base
    self.abstract_class = true

    # Relations
    belongs_to :role, :class_name => "Authorizme::UserRole", :foreign_key => "user_role_id"
    belongs_to :origin_provider, :class_name => "Authorizme::UserProvider"
    has_many :providers, :class_name => "Authorizme::UserProvider"

    # For authorization
    has_secure_password
    attr_accessible :email, :password, :password_confirmation
        
    # Validations
    validates_presence_of :password, :on => :create, :if => :has_not_provider?
    validates_presence_of :password_digest, :on => :create, :if => :has_not_provider?
    validates_presence_of :email, :on => :create, :if => :has_not_provider?
    validates_uniqueness_of :email, :if => :has_not_provider?

    # Filters
    before_create :set_default_role

    def has_not_provider?
      !self.has_provider
    end


    private


      def set_default_role
        new_role = Authorizme::UserRole.find(:first) 
        self.role = new_role if new_role
      end
  end
end