# frozen_string_literal: true
require_relative '../../../lib/generators/coins_paid/migration_data'

class CreateTable < ActiveRecord::Migration[ActiveRecord::Migration.current_version]
  def up
    drop_table :coins_paid_addresses if table_exists?(:coins_paid_addresses)

    migration_data
  end

  def migration_data
    instance_eval CoinsPaid::MigrationData.get
  end
end
