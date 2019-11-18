# frozen_string_literal: true

class CreateTable < ActiveRecord::Migration[ActiveRecord::Migration.current_version]
  def up
    drop_table :coins_paid_addresses if table_exists?(:coins_paid_addresses)

    create_table :coins_paid_addresses do |t|
      t.string :foreign_id, null: false
      t.string :currency, null: false
      t.string :address, null: false
      t.string :tag
      t.integer :external_id, null: false

      t.timestamps
      t.index [:foreign_id, :currency], unique: true
    end
  end

  def down
  end
end
