class CreateTestInvites < ActiveRecord::Migration[8.0]
  def change
    create_table :test_invites do |t|
      t.integer :answer

      t.timestamps
    end
  end
end
