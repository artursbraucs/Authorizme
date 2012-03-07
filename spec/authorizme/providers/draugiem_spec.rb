# encoding: utf-8
require 'spec_helper'
require 'authorizme/provider/draugiem'

module Authorizme
  module Provider
    describe Draugiem do
      it "initialize" do
        draugiem = Draugiem.new
      end

      it "should get login url" do
        options = { 
          draugiem_app_id: Authorizme::draugiem_app_id,
          draugiem_app_key: Authorizme::draugiem_app_id,
          draugiem_api_path: Authorizme::draugiem_app_id,
          redirect_url: "www.domain.com/#{Authorizme::namespace}/login/draugiem/callback" 
        }
        draugiem = Draugiem.new(options)
        draugiem.login_url.should == "http://api.draugiem.lv/authorize/?app=15008309&hash=7c99c985148b6118ed3ee9765b3070b5&redirect=www.domain.com/foo/login/draugiem/callback"
      end

    end
  end
end