class AddMultipleIndexMessage < ActiveRecord::Migration[5.0]
  def change
    add_index :messages, [:chat_id, :number], unique: true
  end
end
