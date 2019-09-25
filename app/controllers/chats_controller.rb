class ChatsController < ApplicationController

  def index
    chats = Chat.all
    render json: chats
    #render json:  {chats.collect { | chat | Application.find(chat.application_id).token } , chats.collect { | chat | chat.number } }
  end

  def show
    @chat = Chat.where(number: params[:chat_num] , application_id: Application.where(token: params[:token])).first
    render json: "chat number is #{params[:chat_num]} belong to application : #{params[:token]} ,, it has #{@chat.messages.count} message/s ____ #{@chat.messages.pluck(:body)} "   if @chat.present?
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
    app = Application.where(token: params[:token]).first
    chat = Chat.where(number: params[:chat_num] , application_id: app.id) if app.present?

    if chat.present?
      @messages = chat.first.messages
      render json: @messages.pluck(:number, :body)
    else
      render json: "No message found with this token and chat number"
    end
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
