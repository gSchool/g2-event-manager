class EventReminder < ActiveRecord::Migration
  def up
    create_table :event_reminders do |t|
      t.integer :event_id
      t.datetime :reminder_time
      t.boolean :sent
    end
  end

  def down
    drop_table :event_reminders
  end
end
