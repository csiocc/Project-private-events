class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |user|
      if user.persisted?
        log_current_user_action("Created user #{user.id} with email #{user.email}")
      end
    end
  end
end