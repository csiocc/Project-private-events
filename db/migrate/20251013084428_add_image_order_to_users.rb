class AddImageOrderToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :image_order, :text
  end
end
