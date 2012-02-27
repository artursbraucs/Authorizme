module Authorizme
  class Engine < Rails::Engine

    initialize "authorizme.load_app_instance_data" do |app|
      Authorizme.setup do |config|
        config.app_root = app.root
      end
    end

  end
end