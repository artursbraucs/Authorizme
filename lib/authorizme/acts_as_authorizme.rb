module Authorizme
  module ActsAsAuthorizme
    extend ActiveSupport::Concern
    
    included do
    end

    module ClassMethods
      def acts_as_authorizme
        # Load bcrypt-ruby only when acts_as_authorizme is called. Need for password digest
        gem 'bcrypt-ruby', '~> 3.0.0'
        require 'bcrypt'
        
        # Relations
        belongs_to :role, :class_name => "Authorizme::UserRole", :foreign_key => "user_role_id"
        belongs_to :origin_provider, :class_name => "Authorizme::UserProvider"
        has_many :providers, :class_name => "Authorizme::UserProvider"
        
        attr_reader :password
        attr_accessible :first_name, :last_name, :image_url, :email, :password, :password_confirmation
        
        # Validations
        validates_confirmation_of :password
        validates_presence_of     :password_digest, :if => :has_not_provider?
        validates_presence_of :email, :on => :create, :if => :has_not_provider?
        validates_uniqueness_of :email, :if => :has_not_provider?

        # Filters
        before_create :set_default_role

        include InstanceMethodsOnActivation

        if respond_to?(:attributes_protected_by_default)
          def self.attributes_protected_by_default
            super + ['password_digest']
          end
        end
      end
    end

    module InstanceMethodsOnActivation
      # Returns self if the password is correct, otherwise false.
      def authenticate(unencrypted_password)
        if BCrypt::Password.new(password_digest) == unencrypted_password
          self
        else
          false
        end
      end

      # Encrypts the password into the password_digest attribute.
      def password=(unencrypted_password)
        @password = unencrypted_password
        unless unencrypted_password.blank?
          self.password_digest = BCrypt::Password.create(unencrypted_password)
        end
      end
      
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
end

ActiveRecord::Base.send :include, Authorizme::ActsAsAuthorizme