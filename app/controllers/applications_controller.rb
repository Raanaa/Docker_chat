class ApplicationsController < ApplicationController

  def index
    apps = Application.all
    render json: apps.pluck(:name , :token , :chats_count)
  end

  def show
    @app = Application.where(token: params[:application_token])
    render json: @app
  end

  def update
    @app = Application.where(token: params[:application_token]).first
    @app.name = params[:name]
    @app.save
    render json: "application name updated to be [ #{@app.name} ]"
  end

  def get_chats
    @chats = Application.where(token: params[:token]) .first.chats
    render json: @chats.pluck(:number , :messages_count)
  end

  def create
		begin
			ActiveRecord::Base.transaction do
				@application = Application.create!(name: params[:name])
      end
    rescue => e #ActiveRecord::RecordNotUnique
      p e.message
      p e.backtrace
			ActiveRecord::Rollback
			render plain: e.message
    end
    render json:" Application created with token = #{@application.token}", status: :created
  end

end
