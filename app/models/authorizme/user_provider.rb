module Authorizme
  class UserProvider < ActiveRecord::Base
    #Relations
    belongs_to :user
    belongs_to :origin_user, :class_name => "User"
    #Validations
    
    # => Attributes
    validates :social_id, :presence => true
    validates :name, :presence => true
    validates :token, :presence => true

    #Filters
    after_save :set_origin_provider_to_user

    #Methods
    def set_origin_provider_to_user
      unless self.origin_user.origin_provider.present?
        self.origin_user.origin_provider_id = self[:id]
        self.origin_user.save
      end
    end
    
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

      private

        def set_user_data user_provider, first_name, last_name, image_url, user
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
end