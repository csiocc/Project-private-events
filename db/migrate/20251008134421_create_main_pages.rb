class CreateMainPages < ActiveRecord::Migration[8.0]
  def change
    create_table :main_pages do |t|
      t.timestamps
    end
  end
end
