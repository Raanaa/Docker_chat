class MessagesController < ApplicationController

  def index
    messages = Message.all
    render json: messages.pluck(:body)
  end

  def show
    chat = Chat.where(number: params[:chat_num] , application_id: Application.where(token: params[:token]).first.id).first
    @message = Message.where(number: params[:msg_num] , chat_id: chat.id).first
    render json: @message
  end

  def update
    chat = Chat.where(number: params[:chat_num] , application_id: Application.where(token: params[:token]).first.id).first
    @message = Message.where(number: params[:msg_num] , chat_id: chat.id).first
    @message.body = params[:body]
    @message.save
    render json: @message
  end

 
  def create
		begin
      ActiveRecord::Base.transaction do
        chat = Chat.where(number: params[:chat_num] , application_id: Application.where(token: params[:token]).first.id).first
				@message = Message.create!(chat_id: chat.id , body: params[:body] )
			end
    rescue => e #ActiveRecord::RecordNotUnique
      p e.message
      p e.backtrace
			ActiveRecord::Rollback
			render json: "Message can not be created , please check application's token and chat's number ______(( #{e.message} ))" and return
    end
    render json: "Message created with number =  #{@message.number}", status: :created
  end


  def search
    query = params[:q].present?
    chat = Chat.where(number: params[:chat_num] , application_id: Application.where(token: params[:token]).first.id).first  if Application.where(token: params[:token]).length > 0
    @messages = Message.search_messages(params[:q] , chat.id) if query and chat

    if @messages.nil?
      render json: "No message found "
    else
      found_msg = Hash.new
      @messages.each do |b|
        found_msg[b.number] = b.body
      end
      render json: "found #{found_msg.size} message/s ________ #{found_msg} "
    end
  end

end
