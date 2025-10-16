class Api::DailyLogsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # POST /api/daily_logs
  def create
    log_date = params[:log_date].presence || Date.today
    log = DailyLog.create!(log_date: log_date, content: params[:content], source: params[:source])
    render json: { id: log.id, status: "created" }, status: :created
  end
end