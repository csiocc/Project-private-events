class CreateInvites < ActiveRecord::Migration[8.0]
  def change
    create_table :invites do |t|
      t.string :title
      t.text :body
      t.integer :answer

      t.timestamps
    end
  end
end
