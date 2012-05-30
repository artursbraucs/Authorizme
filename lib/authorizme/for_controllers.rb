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
    
    def login user
      if current_user && current_user.id != user.id
        if session[:synchronize]
          SynchronizeRequest.create!({user: current_user, requested_user: user, status: "accepted"})
          current_user.synchronize user
          session[:synchronize] = nil
        else
          SynchronizeRequest.create!({user: current_user, requested_user: user})
        end
      else
    	  session[:user_id] = user.id
    	end
    end
    
    def run_require_user
      unless current_user
        not_logged_in_status
      end
    end
    
    def method_missing(meth, *args, &block)
      if meth.to_s =~ /^require_(.+)$/
        if $1 == "user"
          run_require_user
        else
          run_require_role($1, *args, &block)
        end
      else
        super
      end
    end
    
    def run_require_role(role, *args, &block)
      unless current_user && current_user.role.name == role
        not_logged_in_status
      end
    end
    
    def not_logged_in_status
      if Authorizme::remote
        status = {status: "not_logged_in"}
        respond_with status
      else
        redirect_to "/#{Authorizme::namespace}/"
      end
    end
  end
end

ActionController::Base.send :include, Authorizme::ForControllers