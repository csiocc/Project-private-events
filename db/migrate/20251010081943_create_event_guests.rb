class CreateEventGuests < ActiveRecord::Migration[8.0]
  def change
    create_table :event_guests do |t|
      t.references :event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :rsvp_status

      t.timestamps
    end
  end
end
