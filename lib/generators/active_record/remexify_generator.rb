require "rails/generators/active_record"
require "rails/generators/migration"

module ActiveRecord
  module Generators
    class RemexifyGenerator < ActiveRecord::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path("../templates", __FILE__)

      # to avoid next migration numbers having the same exact identity
      @secondth = 1

      def self.next_migration_number(path)
        @secondth += 1
        (Time.now.utc. + @secondth).strftime("%Y%m%d%H%M%S")
      end

      # copy the migration
      def copy_migration
        migration_template "create_remexify_lognotes.rb", "db/migrate/create_remexify_lognotes.rb"
        migration_template "create_remexify_logowners.rb", "db/migrate/create_remexify_logowners.rb"
      end

      # generate appropriate model
      def generate_model
        # don't just call invoke without Rails::Generators because Thor task only run once.
        Rails::Generators.invoke "active_record:model", [name, "--no-migration"]
        Rails::Generators.invoke "active_record:model", ["#{name}Owners", "--no-migration"]
        # invoke "active_record:model", ["Remexify::Logs", "md5:string"], {migration: true, timestamps: true}
      end

      def make_initializer
        template "initialize_remexify.rb", "config/initializers/00_remexify.rb"
      end
    end
  end
end