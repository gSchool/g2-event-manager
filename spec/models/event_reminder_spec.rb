require 'spec_helper'

describe EventReminder do
  it 'adds an event reminder record when an event is created' do
    event = create_event
    create_event_reminder(event.id)

    expect(EventReminder.last.event_id).to eq(event.id)
  end
end