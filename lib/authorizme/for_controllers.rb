module Authorizme
  module ForControllers
    extend ActiveSupport::Concern
    
    included do
    end

    module ClassMethods
      def require_user params = nil
        before_filter :require_user, params
      end
    end

    def current_user
      return @current_user if defined? @current_users
      @current_user ||= User.find session[:user_id] if session[:user_id]
    end
    
    def require_user
      unless current_user
        if Authorizme::remote
          status = {status: "not_logged_in"}
          respond_with status
        else
          redirect_to "/#{Authorizme::namespace}/"
        end
      end
    end
    
  end
end

ActionController::Base.send :include, Authorizme::ForControllers