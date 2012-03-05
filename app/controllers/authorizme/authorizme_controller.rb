module Authorizme
  class AuthorizmeController < ::ApplicationController

    protected

      def login user
      end
  
      def logout
        redirect Authorizme.config.after_logout_path
      end
  end
end