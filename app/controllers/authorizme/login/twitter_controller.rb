module Authorizme
  module Login
    class TwitterController < AuthorizmeController

      def auth
        client = oauth_client
        request_token = client.authentication_request_token(:oauth_callback => redirect_uri("twitter"))
        session[:twitter_request_token] = request_token.token
        session[:twitter_request_secret] = request_token.secret
        redirect_to request_token.authorize_url
      end

      def callback
        if params[:denied]
          respond_with_status "error_in_logging"
        else
          access_token = authorize_with_twitter params[:oauth_token], params[:oauth_verifier]
          twitter_user = Twitter.user
          attributes = {first_name: twitter_user.name, image_url: twitter_user.profile_image_url}
          user = User.authenticate_with_twitter(twitter_user.id, attributes, access_token.token, access_token.secret)
          login user
          respond_with_status "logged_in", user: user
        end
      end

      private
      
        def oauth_client
          TwitterOAuth::Client.new(
              :consumer_key => Authorizme::twitter_consumer_key,
              :consumer_secret => Authorizme::twitter_consumer_secret
          )
        end
        
        def twitter_client access_token
          Twitter.configure do |config|
            config.consumer_key = Authorizme::twitter_consumer_key
            config.consumer_secret = Authorizme::twitter_consumer_secret
            config.oauth_token = access_token.token if access_token.token
            config.oauth_token_secret = access_token.secret if access_token.secret
          end
        end

        def authorize_with_twitter oauth_token, oauth_verifier
          request_token = session[:twitter_request_token]
          request_secret = session[:twitter_request_secret]
          if request_token && request_secret
            client = oauth_client
            access_token = client.authorize(
              request_token,
              request_secret,
              :oauth_verifier => oauth_verifier
            )
            
            twitter_client access_token
            access_token
          end
        end

    end
  end
end