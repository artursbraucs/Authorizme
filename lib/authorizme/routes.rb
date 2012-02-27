module Authorizme
  def self.routes(rails_router)
    rails_router.instance_exec(["login"]) do |namespaces|
      namespaces.each do |namespace|
        get '/login' => 'login#index', :as => 'authorizme_index'
        get '/login/facebook' => 'login#facebook', :as => 'authorizme_login_facebook'
        get '/login/draugiem' => 'login#draugiem', :as => 'authorizme_login_draugiem'
        get '/login/twitter' => 'login#twitter', :as => 'authorizme_login_twitter'
        post '/login' => 'login#create', :as => 'authorizme_login'
        get 'logout' => 'logout#index', :as => 'authorizme_logout_path'
      end
    end
  end
end