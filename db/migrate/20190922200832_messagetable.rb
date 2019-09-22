class Messagetable < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :chat_id, :integer
    add_column :messages, :number, :integer
    add_column :messages, :body, :text
    add_column :messages, :published, :boolean
    add_index :messages, [:chat_id]
  end
end
