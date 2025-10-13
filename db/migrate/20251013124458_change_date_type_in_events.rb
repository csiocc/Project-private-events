class ChangeDateTypeInEvents < ActiveRecord::Migration[8.0]
  def up
    change_column :events, :date, :datetime, using: "date::timestamp"
  end

  def down
    change_column :events, :date, :string
  end
end
