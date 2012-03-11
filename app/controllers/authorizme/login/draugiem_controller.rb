module Authorizme
  module Login
    class DraugiemController < AuthorizmeController
      before_filter :set_draugiem

      def auth
        redirect_to @draugiem.login_url
      end

      def callback
        json = @draugiem.authorize params[:dr_auth_status], params[:dr_auth_code]
        if params[:dr_auth_status] == "ok" && json["users"]
          user_json = json["users"][json["uid"]]
          attributes = {first_name: user_json["name"], last_name: user_json["surname"], image_url: user_json["img"]}
          user = User.authenticate_with_draugiem(json["uid"], attributes, json["apikey"]) 
          login user
          respond_with_status "logged_in", user: user
        else
          respond_with_status "error_in_loggin"
        end
      end

      private

        def set_draugiem
          options = {
            draugiem_app_id: Authorizme::draugiem_app_id,
            draugiem_app_key: Authorizme::draugiem_app_key,
            draugiem_api_path: Authorizme::draugiem_api_path,
            draugiem_api_authorize_path: Authorizme::draugiem_api_authorize_path,
            redirect_url: redirect_uri("draugiem")       
          }
          @draugiem = Authorizme::Provider::Draugiem.new(options)
        end
    end
  end
end