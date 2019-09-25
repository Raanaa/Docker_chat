class ChatsController < ApplicationController

  def index
    chats = Chat.all
    render json: chats.pluck(:number, :messages_count)
  end

  def show
    @chat = Chat.where(number: params[:chat_num] , application_id: Application.where(token: params[:token]).first.id)
    render json: @chat
  end

  def update
    # nothing to update with this model
    #it only has a application_id , number and messages_counts

    # @chat = Chat.where(number: params[:chat_num] , application_id: Application.where(token: params[:token]).first.id)
    # @chat.save
    # render json: @chat

    render json:" nothing to update with this model , it only has a [application_id] , [number] and [messages_counts] "
  end

  def get_messages
    @messages = Chat.where(number: params[:chat_num] , application_id: Application.where(token: params[:token]).first.id).first.messages
    render json: @messages.pluck(:number, :body)
  end

  def create
		begin
			ActiveRecord::Base.transaction do
        @chat = Chat.create!(application_id: Application.where(token: params[:token]).first.id)
      end
    rescue => e #ActiveRecord::RecordNotUnique
      p e.message
      p e.backtrace
			ActiveRecord::Rollback
      render json: "Chat can not be created , please check application's token  ______(( #{e.message} ))" and return
    end
    render json: "Chat created with number =  #{@chat.number}", status: :created
  end

end
