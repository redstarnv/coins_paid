# frozen_string_literal: true
require 'rails/generators/active_record'
require_relative 'migration_data'

module CoinsPaid
  module Generators
    class MigrationGenerator < ActiveRecord::Generators::Base
      argument :name, default: 'create_coins_paid_addresses'
      source_root File.expand_path('templates', __dir__)

      def copy_coins_paid_migration
        migration_template 'migration.rb', "#{db_migrate_path}/#{file_name}.rb"
      end

      def migration_data
        CoinsPaid::MigrationData.get
      end
    end
  end
end
