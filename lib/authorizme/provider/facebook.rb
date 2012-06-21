module Authorizme
  module Provider
    class Facebook

      require "fb_graph"

      attr_accessor :options

      def initialize(options={})
        @options = {client_id: Authorizme::facebook_client_id, secret_id: Authorizme::facebook_client_secret}.merge(options)
        set_client
      end

      def set_client
        options = {client_id: Authorizme::facebook_client_id, secret_id: Authorizme::facebook_client_secret}
        @client ||= FBGraph::Client.new(options)
        @access_token = nil
        if @options[:code] && @options[:redirect_uri]
          @access_token = @client.authorization.process_callback(@options[:code], :redirect_uri => @options[:redirect_uri])
        elsif @options[:signed_request]
          data = FBGraph::Canvas.parse_signed_request(@options[:secret_id], @options[:signed_request])
          @access_token = data["oauth_token"]
          @client.set_token @access_token
        end
        @client     
      end

      def get_client
        @client
      end  

      def get_access_token
        @access_token
      end

      def get_facebook_user
        user_json = @client.selection.me.info!
        image_url = "https://graph.facebook.com/#{user_json.id}/picture?type=large"
        attributes = {first_name: user_json.first_name, last_name: user_json.last_name, image_url: image_url, email: user_json.email}
      end

      private

    end
  end
end