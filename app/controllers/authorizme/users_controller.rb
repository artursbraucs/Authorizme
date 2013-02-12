module Authorizme
  class UsersController < AuthorizmeController
    
    def new
      @user = User.new
    end
    
    def create
      @user = User.new(params[:user])
      @user.password_will_be_update_in_this_request if @user
      if @user.save
        redirect_to root_url, :notice => "Signed up!"
      else
        render "new"
      end
    end
  end
end