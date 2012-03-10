module Authorizme
  class AuthorizmeController < ::ApplicationController
    respond_to :html, :json, :xml

    def index
    end

    protected

      def login user
      	session[:user_id] = user.id
      end
  
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
  end
end