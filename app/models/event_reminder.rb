class EventReminder < ActiveRecord::Base

  has_one :event

  def reminder_time
    start_time = Event.find(self.event_id).start_time.to_time
    self.reminder_time = start_time - (60 * 30)
  end
end