class SetUserroleForExistingUsers < ActiveRecord::Migration[8.0]
  def up
    User.reset_column_information
    User.where(userrole: nil).update_all(userrole: "user")
  end
end
