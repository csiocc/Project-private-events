class AddLikesToPosts < ActiveRecord::Migration[8.0]
  def change
    create_table :post_likes do |t|
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end

    # Optional: Unique Index, damit ein User einen Post nur einmal liken kann!
    add_index :post_likes, [:post_id, :user_id], unique: true
  end
end
