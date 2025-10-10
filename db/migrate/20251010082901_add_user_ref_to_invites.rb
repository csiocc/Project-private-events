class AddUserRefToInvites < ActiveRecord::Migration[8.0]
  def change
    add_reference :invites, :user, null: false, foreign_key: true
  end
end
