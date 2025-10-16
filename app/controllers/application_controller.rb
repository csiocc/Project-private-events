class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  protected

  def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def log_current_user_action(logger_info)
    Rails.logger.info "sending logs to Logger: #{logger_info}"
    DailyLog.create!(
      log_date: Date.today,
      content: logger_info,
      source: "internal_user_controller"
    )
  end
  
end
