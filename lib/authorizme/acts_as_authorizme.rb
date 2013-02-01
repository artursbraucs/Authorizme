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
        has_many :synchronize_requests, :class_name => "Authorizme::SynchronizeRequest"
        
        attr_reader :password
        attr_accessible :first_name, :last_name, :image_url, :email, :password, :password_confirmation
        
        # Validations
        validates_confirmation_of :password
        validates_presence_of     :password_digest, :if => :has_not_provider?
        validates_presence_of :email, :on => :create, :if => :has_not_provider?
        validates_uniqueness_of :email, :if => :has_not_provider?

        # Filters
        before_create :set_default_role

        scope :with_role, joins(:role)

        include InstanceMethodsOnActivation

        if respond_to?(:attributes_protected_by_default)
          def self.attributes_protected_by_default
            super + ['password_digest']
          end
        end
        
        def method_missing(meth, *args, &block)
          if meth.to_s =~ /^authenticate_with_(.+)$/
            run_authenticate_with_provider($1, *args, &block)
          else
            super
          end
        end
        
        protected

          # authorize
          # Finds or creates user provider and creates or updates user with social data
          # => Attributes
          # *provider* provider name, e.g. facebook. Default in gem draugiem, twitter, facebook
          # From args: 
          # *social_id* social network user identity number
          # *attributes* attributes from social nettwork. Can be set: first_name, last_name, image_url 
          # *token* token
          # *secret* secret
          #
          def run_authenticate_with_provider provider, *args, &block          
            social_id = args[0]
            attributes = args[1]
            token = args[2]
            secret = args[3]

            user_provider = Authorizme::UserProvider.find_or_initialize_by_social_id_and_provider_type(social_id.to_s, provider)
            user_provider.token = token
            user_provider.secret = secret if secret
            user_provider.save!
            self.create_or_update_by_provider user_provider, attributes
          end
          
          
          def create_or_update_by_provider provider, attributes
            unless provider.user
              provider.user = User.new
              provider.user.origin_provider = provider
              provider.user.has_provider = true
              provider.user.save!
              provider.origin_user = provider.user
              provider.user
            end
            provider.user.has_provider = true
            provider.user.attributes = attributes
            provider.user.save!
            provider.save!
            provider.user
          end
      end
    end

    module InstanceMethodsOnActivation
      # Returns self if the password is correct, otherwise false.
      def authenticate(unencrypted_password)
        if password_digest && BCrypt::Password.new(password_digest) == unencrypted_password
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

      def has_synchronize_request?
        self.synchronize_requests.status_new.any?
      end
      
      def synchronize other_user
        other_user.providers.each do |other_provider|
          other_provider.update_attributes({user: self})
        end
        on_synchronized other_user
      end

      def to_s
        "#{self.first_name} #{self.last_name}"
      end

      def on_logged_in
      end
      
      def send_password_reset
        set_new_password_reset_token
        self.password_reset_sent_at = Time.zone.now
        self.save!
        send_password_reset_notification
      end
      
      def set_new_password_reset_token
        begin
          self.password_reset_token = SecureRandom.urlsafe_base64
        end while User.exists?(:password_reset_token => self.password_reset_token)
      end
      
      private
        
        def send_password_reset_notification
        end
        
        def on_synchronized old_user
        end
        
        def set_default_role
          new_role = Authorizme::UserRole.find(:first) 
          self.role = new_role if new_role
        end
    end
  end
end

ActiveRecord::Base.send :include, Authorizme::ActsAsAuthorizme