module Authorizme
  class AuthorizmeController < ::ApplicationController
    respond_to :html, :json, :xml
    layout "authorizme/layouts/popup"

    def index
      @user = current_user
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
      
      def render_popup_view
        render "popup", :layout => "authorizme/layouts/popup"
      end
      
      def respond_with_status status_name, attributes = nil
        status = {status: status_name}
        status = status.merge(attributes) if attributes
        respond_with status
      end
      
      def redirect_uri provider
        if Rails.env.development?
          "http://#{request.host}:#{request.port}/#{Authorizme::namespace}/login/#{provider}/callback"
        else
          "http://#{request.host}/#{Authorizme::namespace}/login/#{provider}/callback"
        end
      end
  end
end