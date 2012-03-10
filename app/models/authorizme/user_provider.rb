module Authorizme
  class UserProvider < ActiveRecord::Base
    #Relations
    belongs_to :user
    belongs_to :origin_user, :class_name => "User"

    #Validations
    # => Attributes
    validates :social_id, :presence => true
    validates :token, :presence => true

    # TODO: must get rid off methods in UserProvider model
    class << self
      
      # <b>DEPRECATED:</b>
      def create_or_get_by_facebook fb_user, access_token, user = nil
        warn "[DEPRECATION] `create_or_get_by_facebook` is deprecated."
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
      
      # <b>DEPRECATED:</b> Please use <tt>useful</tt> instead.
      def self.set_user_data user_provider, first_name, last_name, image_url, user
        warn "[DEPRECATION] `set_user_data` is deprecated.  Please use `User.create_or_update_by_provider` instead."
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