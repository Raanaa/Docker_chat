class Deletesingleindexchat < ActiveRecord::Migration[5.0]
  def change
    remove_index "messages", name: "index_messages_on_chat_id"
    remove_index "chats", name: "index_chats_on_application_id"
  end
end
