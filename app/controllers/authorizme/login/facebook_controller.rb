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
        session[:access_token] = access_token
        user_json = client.selection.me.info!
        respond_with_status "logged_in", user: user_json
      end
      
      private
      
        def client
            @client ||= FBGraph::Client.new(:client_id => Authorizme::facebook_client_id,
                                           :secret_id => Authorizme::facebook_client_secret)
        end
    end
  end
end