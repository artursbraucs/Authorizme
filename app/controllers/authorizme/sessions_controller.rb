module Authorizme
  class SessionsController < AuthorizmeController
  
    def create
      user = User.find_by_email(params[:email])
      if user && user.authenticate(params[:password])
        login user
        respond_with({status: "logged_in", user: user}, :location => Authorizme::after_login_path)
      else
        respond_with({status: "authorization_faild", user: user}, {:location => Authorizme::not_logged_in_path, :status => :not_found})
      end
    end
    
    def destroy
      logout
    end

  end
end