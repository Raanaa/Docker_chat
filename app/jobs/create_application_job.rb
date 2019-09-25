class CreateApplicationJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
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
  end
end
