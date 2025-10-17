class RemovePostIdFromComments < ActiveRecord::Migration[8.0]
  def change
    if column_exists?(:comments, :post_id)
      remove_column :comments, :post_id, :bigint
    end
  end
end
