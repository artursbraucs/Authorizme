Rails.application.routes.draw do
  get '/login' => 'authorizme/login#index', :as => 'authorizme_index'
  get '/login/facebook' => 'authorizme/login#facebook', :as => 'authorizme_login_facebook'
  get '/login/draugiem' => 'authorizme/login#draugiem', :as => 'authorizme_login_draugiem'
  get '/login/twitter' => 'authorizme/login#twitter', :as => 'authorizme_login_twitter'
  post '/login' => 'authorizme/login#create', :as => 'authorizme_login'
  get '/logout' => 'authorizme/logout#index', :as => 'authorizme_logout'
end