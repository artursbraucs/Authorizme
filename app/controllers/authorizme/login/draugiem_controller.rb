module Authorizme
  module Login
    class Authorizme::Login::DraugiemController < AuthorizmeController
      respond_to :html, :json, :xml
      before_filter :set_draugiem

      def auth
        redirect_to @draugiem.login_url
      end

      def callback
        data = @draugiem.authorize params[:dr_auth_status], params[:dr_auth_code]

        json = JSON.parse(data)

        if json["users"]
          user_json = json["users"][json["uid"]]
          attributes = {first_name: user_json["name"], last_name: user_json["surname"], image_url: user_json["img"]}
          user = UserProvider.authorize("draugiem", json["uid"], attributes, json["apikey"])
          login user
        end
        respond_with json
      end

      private

        def set_draugiem
          options = {
            draugiem_app_id: Authorizme::draugiem_app_id,
            draugiem_app_key: Authorizme::draugiem_app_key,
            draugiem_api_path: Authorizme::draugiem_api_path,
            draugiem_api_authorize_path: Authorizme::draugiem_api_authorize_path,
            redirect_url: "http://#{request.host}:#{request.port}/#{Authorizme::namespace}/login/draugiem/callback.json"         
          }
          @draugiem = Authorizme::Provider::Draugiem.new(options)
        end
    end
  end
end