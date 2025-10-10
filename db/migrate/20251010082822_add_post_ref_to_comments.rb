class AddPostRefToComments < ActiveRecord::Migration[8.0]
  def change
    add_reference :comments, :post, null: false, foreign_key: true
  end
end
