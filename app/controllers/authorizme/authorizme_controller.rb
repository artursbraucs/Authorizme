module Authorizme
  class AuthorizmeController < ::ApplicationController
    respond_to :html, :json, :xml

    def index
    end

    protected

      def login user
      	session[:user_id] = user.id
        if Authorizme::remote
          respond_with {:status => "logged_in", :user => user}
        else
          redirect_to Authorizme::after_login_path
        end
      end
  
      def logout
      	session[:user_id] = nil
        if Authorizme::remote
          respond_with {:status => "logged_out"}
        else
          redirect_to Authorizme::after_logout_path
        end
      end
  end
end