module Authorizme
  class SessionsController < AuthorizmeController
  
    def create
      user = User.find_by_email(params[:email])
      if user && user.authenticate(params[:password])
        login user
        if Authorizme::remote
          status = {status: "logged_in", user: user}
          respond_with status
        else
          redirect_to Authorizme::after_login_path
        end
      else
        flash.now.alert = "Invalid email or password"
        render "new"
      end
    end

  end
end