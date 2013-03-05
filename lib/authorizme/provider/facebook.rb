module Authorizme
  module Provider
    class Facebook

      require "fb_graph"

      attr_accessor :options

      def initialize(options={})
        @options = options
        init_client
      end

      def get_client
        @client
      end  

      def get_access_token
        @access_token
      end

      def get_user_json
        @user_json ||= @client.selection.me.info! if @access_token
      end

      def get_user
        user_json = get_user_json
        if user_json
          if @options[:image_size]
            width = @options[:image_size][:width]
            height = @options[:image_size][:height]
            image_url = "https://graph.facebook.com/#{user_json.id}/picture?width=#{width}&height=#{height}" 
          else
            image_url = "https://graph.facebook.com/#{user_json.id}/picture?type=large" 
          end
          attributes = {first_name: user_json.first_name, last_name: user_json.last_name, image_url: image_url, email: user_json.email}
          return attributes
        else
          return nil
        end
      end

      def get_signed_request_data
        if @signed_request_data 
          return @signed_request_data
        else
          return nil
        end
      end

      def authorize_with_code code, redirect_uri
        @access_token = @client.authorization.process_callback(code, :redirect_uri => redirect_uri)
        return @access_token != nil
      end

      def authorize_with_signed_request signed_request
        @signed_request_data = FBGraph::Canvas.parse_signed_request(@options[:client_secret], signed_request)
        @access_token = @signed_request_data["oauth_token"] if @signed_request_data["oauth_token"]
        @client.set_token @access_token if @client
        return @access_token != nil
      end

      def get_popup_authorize_url callback_url, scope
        @client.authorization.authorize_url(:redirect_uri => callback_url, 
                                                      :scope => scope, 
                                                      :display => "popup")
      end

      def get_dialog_authorize_url callback_url, scope
        "https://www.facebook.com/dialog/oauth/?client_id=#{@options[:client_id]}&redirect_uri=#{CGI.escape(callback_url)}&scope=#{scope}"
      end

      private

        def init_client
          @client = nil
          @access_token = nil
          if @options[:client_id] && @options[:client_secret]
            options = {client_id: @options[:client_id], secret_id: @options[:client_secret]}
            @client = FBGraph::Client.new(options)
          end
          @client     
        end

    end
  end
end