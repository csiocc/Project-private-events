class AddDatingProfileToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :location, :string
    add_column :users, :profile_text, :text
    add_column :users, :gender, :string
    add_column :users, :show_gender_preferences, :string
  end
end
