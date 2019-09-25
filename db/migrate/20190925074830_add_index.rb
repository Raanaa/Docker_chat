class AddIndex < ActiveRecord::Migration[5.0]
  def change
    add_index :chats, [:application_id, :number], unique: true
  end
end
