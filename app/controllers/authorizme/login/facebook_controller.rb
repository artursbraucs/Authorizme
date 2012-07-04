module Authorizme
  module Login
    class FacebookController < AuthorizmeController
      before_filter :set_facebook, :only => [:auth, :callback, :canvas]

      def auth
        callback_url = params[:callback_url] || redirect_uri("facebook")        
        if params[:canvas]
          @authorize_url = @facebook.get_dialog_authorize_url callback_url, Authorizme::facebook_perms
        else
          redirect_to @facebook.get_popup_authorize_url callback_url, Authorizme::facebook_perms
        end
      end

      def callback
        if params[:signed_request]
          @facebook.authorize_with_signed_request params[:signed_request]
          authorize_user @facebook
          redirect_to Authorizme::after_login_path
        elsif params[:code]
          @facebook.authorize_with_code params[:code], redirect_uri("facebook")
          authorize_user @facebook
          render_popup_view
        else
          redirect_to Authorizme::after_login_path
        end
      end
      
      private

        def set_facebook
          options = {client_id: Authorizme::facebook_client_id, client_secret: Authorizme::facebook_client_secret}
          @facebook = Authorizme::Provider::Facebook.new(options)
        end

        def authorize_user facebook
          fb_user = facebook.get_user
          if fb_user[:email]
            user = User.find_by_email(fb_user[:email])
            if user
              fb_user.delete(:email)
            end
          end
          user = User.authenticate_with_facebook(facebook.get_user_json.id, fb_user, facebook.get_access_token) 
          login user
          user
        end

    end
  end
end