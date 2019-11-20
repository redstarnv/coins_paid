# frozen_string_literal: true

module CoinsPaid
  module MigrationData
    module_function

    def get
<<RUBY
    create_table :coins_paid_addresses do |t|
      t.string :foreign_id, null: false
      t.string :currency, null: false
      t.string :address, null: false
      t.string :tag
      t.integer :external_id, null: false
 
      t.timestamps
      t.index [:foreign_id, :currency], unique: true
    end
RUBY
    end
  end
end
