class CreateDailyLogReads < ActiveRecord::Migration[8.0]
  def change
    create_table :daily_log_reads do |t|
      t.references :user, null: false, foreign_key: true
      t.references :daily_log, null: false, foreign_key: true
      t.boolean :read

      t.timestamps
    end
  end
end
