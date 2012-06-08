module Authorizme
  class SessionsController < AuthorizmeController
  
    def create
      user = User.find_by_email(params[:email])
      if user && user.authenticate(params[:password])
        login user
        if Authorizme::remote
          respond_with_status "logged_in", {user: user}
        else
          redirect_to Authorizme::after_login_path
        end
      else
        if Authorizme::remote
          status = {status: "authorization_faild"}
          respond_with(status, {:location => nil, :status => :not_found})
        else
          render "new"
        end
      end
    end
    
    def destroy
      logout
    end

  end
end