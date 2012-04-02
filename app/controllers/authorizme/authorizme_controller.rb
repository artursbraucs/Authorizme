module Authorizme
  class AuthorizmeController < ::ApplicationController
    respond_to :html, :json, :xml

    def index
    end

    protected
      
      def logout
      	session[:user_id] = nil
        if Authorizme::remote
          respond_with_status "logged_out"
        else
          redirect_to Authorizme::after_logout_path
        end
      end
      
      def respond_with_status status_name, attributes = nil
        status = {status: status_name}
        status = status.merge(attributes) if attributes
        respond_with status
      end
      
      def redirect_uri provider
        if Rails.env.development?
          redirect_url = "http://localhost:3000/authorizme/login/#{provider}/callback.json"
        else
          "http://#{request.host}/#{Authorizme::namespace}/login/#{provider}/callback"
        end
      end
      
      def request_synchronize user
      end
  end
end