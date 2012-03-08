Rails.application.routes.draw do
  # All authorizme routes will be under custom namespace
  namespace Authorizme::namespace do
  	resources :sessions
    resources :users
    
    get '/' => 'authorizme#index', :as => 'main'
    get '/signup' => 'users#new', :as => 'signup' 
    get '/login/facebook' => 'login#facebook', :as => 'login_facebook'
    
    get '/login/draugiem' => 'login/draugiem#auth', :as => 'login_draugiem'
    get '/login/draugiem/callback' => 'login/draugiem#callback', :as => 'login_draugiem_callback'

    get '/login/twitter' => 'login#twitter', :as => 'login_twitter'
    post '/login' => 'login#create', :as => 'login'
    get '/logout' => 'logout#index', :as => 'logout'
  end
end