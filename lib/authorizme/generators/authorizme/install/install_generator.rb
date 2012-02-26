module Authorizme
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Installs Authorizme and generats the necessary migrations"
      argument :name, :type => :string, :default => "User"

      include Rails::Generators::Migration

      def self.source_root
        @_authorizme_source_root ||= File.expand_path("../templates", __FILE__)
      end  

      def self.next_migration_number(dirname)
        Time.now.strftime("%Y%m%d%H%M%S")
      end

      def copy_initializer
        @underscored_user_name = name.underscore
        template 'authorizme.rb.erb', 'config/initializers/authorizme.rb'
      end

      def create_model
        empty_directory "app/admin"
        template 'models/user.rb', 'app/models/user.rb'
      end

      def setup_routes
        route "Authorizme.routes(self)"
      end

      def create_migrations
        Dir["#{self.class.source_root}/migrations/*.rb"].sort.each do |filepath|
          name = File.basename(filepath)
          migration_template "migrations/#{name}", "db/migrate/#{name.gsub(/^\d+_/,'')}"
          sleep 1
        end
      end
    end
  end
end