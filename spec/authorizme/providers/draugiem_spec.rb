# encoding: utf-8
require 'spec_helper'
require 'authorizme/provider/draugiem'

module Authorizme
  module Provider
    describe Draugiem do

        options = { 
          draugiem_app_id: Authorizme::draugiem_app_id,
          draugiem_app_key: Authorizme::draugiem_app_key,
          redirect_url: "http://domain.com/#{Authorizme::namespace}/login/draugiem/callback/" 
        }
        draugiem = Draugiem.new(options)

      it "initialize" do
        draugiem.should_not be_nil
      end

      it "should get login url" do
        draugiem.login_url.should == "http://api.draugiem.lv/authorize/?app=15008309&hash=54154816b1ed5a660b6ba4e18440e248&redirect=http://domain.com/authorizme/login/draugiem/callback/"
      end

    end
  end
end