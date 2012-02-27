class AuthorizmeController < ActionController::Base
  
  protected
  
    def login user
    end
    
    def logout
      redirect Authorizme.config.after_logout_path
    end
    
end