class DailyLogsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!

  # GET /daily_logs or /daily_logs.json
  def index
    all_dates = DailyLog.distinct.pluck(:log_date)
    read_dates = current_user.read_daily_logs.distinct.pluck(:log_date)
    @read_dates   = all_dates & read_dates      # Tage, für die der User Logs gelesen hat
    @unread_dates = all_dates - read_dates      # Tage, für die der User noch nichts gelesen hat
  end

  def show
    @date = params[:id]
    logs = DailyLog.where(log_date: @date)
    @read_logs   = logs.where(id: current_user.read_daily_logs.where(log_date: @date))
    @unread_logs = logs.where.not(id: current_user.read_daily_logs.where(log_date: @date))
  end

  def new
  end

  def edit
    @log = DailyLog.find(params[:id])
  end

  def update
    @log = DailyLog.find(params[:id])
    @log.update(log_params)
    redirect_to daily_log_path(@log.log_date), notice: "Log-Eintrag aktualisiert"
  end

  def destroy
    @log = DailyLog.find(params[:id])
    date = @log.log_date
    @log.destroy
    redirect_to daily_log_path(date), notice: "Log-Eintrag gelöscht"
  end

  def unread_count
    # Zeigt die Anzahl aller Logs, die der aktuelle User NICHT gelesen hat
    count = DailyLog.where.not(id: current_user.read_daily_logs).count
    render json: { unread_count: count }
  end

  def mark_as_read
    log = DailyLog.find(params[:id])
    DailyLogRead.find_or_create_by(user: current_user, daily_log: log, read: true)
    redirect_to daily_logs_path, notice: "Log als gelesen markiert."
  end

  def mark_all_as_read
    current_user.unread_daily_logs.find_each do |log|
      DailyLogRead.find_or_create_by(user: current_user, daily_log: log, read: true)
    end
    redirect_to daily_logs_path, notice: "Alle Logs als gelesen markiert."
  end

  private

  def log_params
    params.require(:daily_log).permit(:content, :source)
  end

  def ensure_admin!
    unless current_user.userrole == "admin"
      Rails.logger.warn "Unbefugter Zugriff von Benutzer #{current_user.id} auf DailyLogsController userrole is: #{current_user.userrole}"
      redirect_to root_path, notice: "Zugriff verweigert."
    end
  end



end