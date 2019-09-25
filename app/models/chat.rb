class Chat < ApplicationRecord

    after_create :update_chats_count
    validates_uniqueness_of :number, scope: :application_id
    belongs_to :application
    has_many :messages, dependent: :destroy

    before_validation( :on => :create ) do 
        app_chats_nums = self.application.chats.collect { | chat | chat.number }
        self.number = app_chats_nums.empty? ? 1 :app_chats_nums.max+1
    end

end


private

def update_chats_count
    a = self.application
    if a.chats_count.nil?
        a.chats_count = 1
    else
        a.chats_count += 1
    end
    a.save
end