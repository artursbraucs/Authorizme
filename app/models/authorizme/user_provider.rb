module Authorizme
  class UserProvider < ActiveRecord::Base
    #Relations
    belongs_to :user
    belongs_to :origin_user, :class_name => "User"

    #Validations
    # => Attributes
    validates :social_id, :presence => true
    validates :token, :presence => true

    class << self

      def create_or_get_by_draugiem json, user = nil
        userParams = JSON.parse(json)

        if userParams['users']
          userJson = userParams['users'][userParams['uid']]
          user_provider = UserProvider.find_or_create_by_social_id_and_provider_type(userParams['uid'], "draugiem")

          user = UserProvider.set_user_data(user_provider, userJson['name'], userJson['surname'], userJson['img'], user)

          user_provider.token = userParams['apikey']
          user_provider.user = user

          if user_provider.id == nil
            user_provider.origin_user = user
          end

          user_provider.save

          return user
        else
          return nil
        end
      end

      def create_or_get_by_facebook fb_user, access_token, user = nil
        user_provider = UserProvider.find_or_create_by_social_id_and_provider_type(fb_user.identifier.to_i, "facebook")
        user = UserProvider.set_user_data(user_provider, fb_user.first_name, fb_user.last_name, fb_user.picture + '?type=large', user)

        user_provider.token = access_token
        user_provider.user = user

        if user_provider.id == nil
          user_provider.origin_user = user
        end

        user_provider.save

        return user
      end

      # authorize
      # Finds or creates user provider and creates or updates user with social data
      # => Attributes
      # *provider_type* provider name, e.g. facebook. Default in gem draugiem, twitter, facebook
      # *social_id* social network user identity number
      # *attributes* attributes from social nettwork. Can be set: first_name, last_name, image_url 
      # *token* token
      # *secret* secret
      #
      def authorize provider_type, social_id, attributes = {}, token = nil, secret = nil
        user_provider = UserProvider.find_or_initialize_by_social_id_and_provider_type(social_id.to_s, provider_type)
        user_provider.token = token
        user_provider.secret = secret if secret
        user_provider.save!
        user_provider.create_or_update_user attributes
        self.user
      end

    end

    def create_or_update_user attributes
      unless self.user
        self.user = User.new
        self.user.origin_provider = self
        self.user.has_provider = true
        self.user.save!
        self.origin_user = self.user
      end
      self.user.has_provider = true
      self.user.update_attributes!(attributes)
    end

    private



      def self.set_user_data user_provider, first_name, last_name, image_url, user
        if user != nil
          user_provider.user = user
        else
          if user_provider.user
            user = user_provider.user
            user.image_url = image_url
            user.save
          else
            user = User.new
            user.first_name = first_name
            user.last_name = last_name if last_name
            user.image_url = image_url
            user.save!
          end
        end
        user
      end
  end
end