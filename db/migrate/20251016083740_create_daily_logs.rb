class CreateDailyLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :daily_logs do |t|
      t.date :log_date
      t.text :content
      t.string :source

      t.timestamps
    end
  end
end
