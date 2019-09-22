class Applicationtimestamp < ActiveRecord::Migration[5.0]
  def change
    add_column :applications, :created_at, :datetime, null: false
    add_column :applications, :updated_at, :datetime, null: false
  end
end
