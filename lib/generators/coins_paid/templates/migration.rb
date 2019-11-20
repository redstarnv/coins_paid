# frozen_string_literal: true

class Create<%= table_name.camelize %> < ActiveRecord::Migration[<%= ActiveRecord::Migration.current_version %>]
  def change
<%= migration_data %>
  end
end
