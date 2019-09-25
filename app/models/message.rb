class Message < ApplicationRecord

    after_create :update_messages_count
    validates_uniqueness_of :number, scope: :chat_id
    belongs_to :chat
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    before_validation( :on => :create ) do
        chat_messages_nums = self.chat.messages.collect { | m | m.number }
        self.number = chat_messages_nums.empty? ? 1 :chat_messages_nums.max+1
    end

    settings do
      mappings dynamic: false do
        indexes :chat_id, type: :integer
        indexes :number, type: :integer
        indexes :body, type: :text, analyzer: :english
        indexes :published, type: :boolean
      end
    end

    def self.search_messages(query , given_chat_id)
        result = self.search({
           "size": 1000,
            query: {
              bool: {
                must: [
                {
                  multi_match: {
                    query: query,
                    fields: [:body]
                  }
                },
                {
                  match: {
                    "chat_id": given_chat_id.to_i
                  }
                }]
              }
            }
          })
    end
end
#Message.import # force: true


private

def update_messages_count
    a = self.chat
    if a.messages_count.nil?
        a.messages_count = 1
    else
        a.messages_count += 1
    end
    a.save
end