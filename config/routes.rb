Rails.application.routes.draw do
  # All authorizme routes will be under custom namespace
  namespace Authorizme::namespace do
  	resources :sessions
    resources :users
    resources :password_resets
    
    get '/' => 'authorizme#index', :as => 'main'
    get '/signup' => 'users#new', :as => 'signup' 
    
    # Declare all provider routes.
    Authorizme::providers.each do |provider|
      get "/login/#{provider}" => "login/#{provider}#auth", :as => "#{provider}_login"
      get "/login/#{provider}/callback" => "login/#{provider}#callback", :as => "#{provider}_callback"
    end
    
    post '/login' => 'sessions#create', :as => 'login'
    get '/logout' => 'sessions#destroy', :as => 'logout'
  end
end