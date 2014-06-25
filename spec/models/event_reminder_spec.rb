require 'spec_helper'

describe EventReminder do
  it 'adds an event reminder record when an event is created' do
    event = create_event
    create_event_reminder(event.id)

    expect(EventReminder.last.event_id).to eq(event.id)
  end

  it 'sets a reminder time' do
    event = Event.create!(
      name: "#{Faker::Lorem.word.capitalize} Meetup",
      location: Faker::Address.city,
      date: rand(25).days.from_now,
      description: Faker::Company.catch_phrase,
      capacity: rand(30)+10,
      category: Faker::Commerce.department,
      start_time: 24.hours.from_now
    )
    create_event_reminder(event.id)
    expected = (event.start_time.to_time - (60 * 30))

    expect(EventReminder.last.reminder_time).to eq(expected)
  end
end