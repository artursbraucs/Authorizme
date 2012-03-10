module Authorizme
  module Provider
    class Draugiem

      attr_accessor :options
      # Options:
      #
      # draugiem_app_id 
      # draugiem_app_key
      # draugiem_api_path
      # draugiem_api_authorize_path
      # redirect_url
      #
      def initialize(options={})
        @options = {
          draugiem_api_path: "http://api.draugiem.lv/json/",
          draugiem_api_authorize_path: "http://api.draugiem.lv/authorize/"
        }.merge(options)
      end

      def login_url
        puts "App key: #{@options[:draugiem_app_key]}"
        puts "Redirect url: #{@options[:redirect_url]}"
        hash = Digest::MD5.hexdigest(@options[:draugiem_app_key] + @options[:redirect_url])
        "#{@options[:draugiem_api_authorize_path]}?app=#{@options[:draugiem_app_id]}&hash=#{hash}&redirect=#{@options[:redirect_url]}"
      end

      def authorize dr_auth_status, dr_auth_code
        gem 'json'
        require 'json'
        
        return nil unless dr_auth_status
        if dr_auth_status == 'ok'
          params = { :action => 'authorize', 'app' => @options[:draugiem_app_key], 'code' => dr_auth_code }
          response = login_params params
          json = JSON.parse(response)
          return json
        end
      end

      private

        def login_params params
          response = request_curl(@options[:draugiem_api_path], params)
        end

        def request_curl url, params = { }
          #Requirements
          require "net/http"
          require "uri"
          uri = URI.parse("#{url}?#{params.to_query}")
          http = Net::HTTP.new(uri.host, uri.port)
          res = http.get(uri.request_uri)
          res.body
        end
    end
  end
end