module Authorizme
  module Login
    class FacebookController < AuthorizmeController

      def auth
        client = get_client
        redirect_to client.authorization_uri(:scope => [:email, :read_stream, :offline_access], :display => "popup")
      end

      def callback
        error = params[:error_reason]

        unless error
          client = get_client
          client.authorization_code = params[:code]
          access_token = client.access_token!
          fb_user = FbGraph::User.me(access_token).fetch
          
          user = User.authenticate_with_draugiem(json["uid"], attributes, json["apikey"]) 
          login user
          respond_with_status "logged_in", user: user
        end
      end
      
      private
      
        def get_client
          fb_auth = FbGraph::Auth.new(Authorizme::facebook_client_id, Authorizme::facebook_client_secret)
          client = fb_auth.client
          client.redirect_uri = "http://#{request.host}:#{request.port}/#{Authorizme::namespace}/login/facebook/callback.json"
          client
        end

        def oauth2_error(e)
          respond_with_status "error_in_loggin", error: e.response[:error][:message]
        end

    end
  end
end