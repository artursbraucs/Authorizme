module Authorizme
  class PasswordResetsController < AuthorizmeController
    def new
    end

    def create
      user = User.find_by_email(params[:email])
      user.send_password_reset if user
      if user
        respond_with user, :location => root_url
      else
        respond_with nil, :location => root_url
      end
    end
  
    def edit
      @user = User.find_by_password_reset_token!(params[:id])
    end
  
    def update
      @user = User.find_by_password_reset_token!(params[:id])
      if @user.password_reset_sent_at < 2.hours.ago
        respond_with @user, :location => authorizme_new_password_reset_path, :alert => "Password reset has expired." 
      elsif @user.update_attributes(params[:user])
        respond_with @user, :location => root_url, :notice => "Password has been reset!"
      else
        render :edit
      end
    end
  end
end