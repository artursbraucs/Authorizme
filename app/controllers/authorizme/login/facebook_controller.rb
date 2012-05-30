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
        render_popup_view
      end
      
      private
      
        def client
            @client ||= FBGraph::Client.new(:client_id => Authorizme::facebook_client_id,
                                           :secret_id => Authorizme::facebook_client_secret)
        end
    end
  end
end