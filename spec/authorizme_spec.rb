# encoding: utf-8
require 'spec_helper'

describe Authorizme do
  describe "#configure" do
    it "passes Authorizme to the given block" do
      Authorizme.setup do |config|
        config.namespace = 'foo'
      end
      Authorizme.namespace.should == 'foo'
    end

    it "get default from configs" do
      Authorizme.draugiem_api_path.should == "http://api.draugiem.lv/json/"
    end
  end  
end