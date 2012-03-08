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
          status = {status: "logged_out"}
          respond_with status
        else
          redirect_to Authorizme::after_logout_path
        end
      end
  end
end