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
    
    def find_registred_email
      user = User.find(:first, :conditions => [ "lower(email) = ?", params[:email].downcase ])
      provider = user && user.origin_provider ? user.origin_provider.provider_type : false
      respond_with({ email: params[:email], registred: user.present?, provider: provider}, {location: nil})
    end
    
  end
end