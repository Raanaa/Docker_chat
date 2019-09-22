class Chattable < ActiveRecord::Migration[5.0]
  def change
    add_column :chats, :application_id, :integer
    add_column :chats, :number, :integer
    add_column :chats, :messages_count, :integer
    add_index :chats, [:application_id]
  end
end
