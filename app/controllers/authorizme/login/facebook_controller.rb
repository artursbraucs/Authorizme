module Authorizme
  module Login
    class FacebookController < AuthorizmeController
      
      def auth
        redirect_to client.authorization.authorize_url(:redirect_uri => redirect_uri("facebook"), 
                                                      :scope => Authorizme::facebook_perms, 
                                                      :display => "popup")
      end

      def callback
        access_token = client.authorization.process_callback(params[:code], :redirect_uri => redirect_uri("facebook"))
        authorize_user client, access_token
        render_popup_view
      end

      def canvas
        @facebook = Authorizme::Provider::Facebook.new(signed_request: params[:signed_request])
        user = authorize_user @facebook.get_client, @facebook.get_access_token
        respond_with user, :location => nil
      end
      
      private
      
        def client token = nil
          options = {client_id: Authorizme::facebook_client_id, secret_id: Authorizme::facebook_client_secret}
          options[:token] =  token if token
          @client ||= FBGraph::Client.new(options)
        end

        def authorize_user client, access_token
          user_json = client.selection.me.info!
          image_url = "https://graph.facebook.com/#{user_json.id}/picture?type=large"
          attributes = {first_name: user_json.first_name, last_name: user_json.last_name, image_url: image_url}
          if user_json.email
            user = User.find_by_email(user_json.email)
            unless user
              attributes[:email] = user_json.email
            end
          end
          user = User.authenticate_with_facebook(user_json.id, attributes, access_token) 
          login user
          user
        end

    end
  end
end