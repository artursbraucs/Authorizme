class Authorizme::Login::DraugiemController < ApplicationController

  def auth
    draugiem = Authorizme::Provider::Draugiem.new(get_options)
    redirect_to draugiem.login_url
  end

  def callback
  end

  private

    def get_options
      { 
        draugiem_app_id: Authorizme::draugiem_app_id,
        draugiem_app_key: Authorizme::draugiem_app_id,
        draugiem_api_path: Authorizme::draugiem_app_id,
        redirect_url: "#{request.host}/#{Authorizme::namespace}/login/draugiem/callback" 
      }
    end

end