class Applicationtable < ActiveRecord::Migration[5.0]
  def change
    add_column :applications, :name, :string
    add_column :applications, :token, :string
    add_column :applications, :chats_count, :integer
    add_index :applications, [:token], unique: true
  end
end
