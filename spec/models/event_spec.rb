require 'spec_helper'

describe Event do
  before do
    user = User.new(email: 'bob@bob.com', password: '12341234', password_confirmation: '12341234')
    @event = Event.create!(
      name: "Test Meetup",
      location: "Boulder, CO",
      date: 1.days.from_now,
      description: "This is a description",
      capacity: 1,
      category: "test",
      start_time: "07:00",
      end_time: "08:00",
    )
    Registration.create!(event: @event, user: user, role: :guest)
  end

  it "can return the number of attendees for a given event" do
    actual = @event.number_of_registrations
    expected = 1
    expect(actual).to eq expected
  end

  it "returns number of tickets remaining" do
    actual = @event.tickets_remaining
    expected = 0
    expect(actual).to eq expected
  end

  it "can format events to ics" do
    user = User.create!(email: 'jim@bob.com', password: 'Pa12341234')

    event = Event.create!(
      name: "Meetup",
      location: "Pepsi Center",
      city: "Denver",
      date: Time.at(2014-06-20),
      description: "This is a description",
      capacity: 1,
      category: "test",
      start_time: "07:00",
      end_time: "08:00"
    )

    event2 = Event.create!(
      name: "Test Meetup",
      location: "Galvanize",
      city: "Boulder",
      date: Time.at(2014-06-20),
      description: "This is a description",
      capacity: 1,
      category: "test",
      start_time: "07:00",
      end_time: "08:00"
    )

    Registration.create!(event: event, user: user, role: :guest)
    Registration.create!(event: event2, user: user, role: :guest)

    timestamp = Time.now.strftime("%Y%m%dT%H%M%SZ")

    expected = <<-INPUT.strip
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//hacksw/handcal//NONSGML v1.0//EN
BEGIN:VEVENT
UID:#{event.id}
DTSTAMP:#{timestamp}
DTSTART:19691231T190000Z
DTEND:19691231T200000Z
SUMMARY:#{event.name} - guest
DESCRIPTION:This is a description
LOCATION:Pepsi Center, Denver
END:VEVENT
BEGIN:VEVENT
UID:#{event2.id}
DTSTAMP:#{timestamp}
DTSTART:19691231T190000Z
DTEND:19691231T200000Z
SUMMARY:#{event2.name} - guest
DESCRIPTION:This is a description
LOCATION:Galvanize, Boulder
END:VEVENT
END:VCALENDAR
    INPUT

    all_events = user.attended_events

    expect(Event.to_ics(all_events, user)).to eq expected
  end

  it 'takes a user and an event and will return the registration role' do
    user = User.create!(email: 'jim@bob.com', password: 'Pa12341234')

    event = Event.create!(
      name: "Meetup",
      location: "Pepsi Center",
      city: "Denver",
      date: 2.days.from_now,
      description: "This is a description",
      capacity: 1,
      category: "test",
      start_time: "07:00",
      end_time: "08:00"
    )

    Registration.create!(event: event, user: user, role: :guest)

    expect(Event.registration_role(user, event)).to eq "guest"
  end
end