require 'spec_helper'

describe Event do
  describe "registrations" do
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

  describe 'ics format' do

    before do
      @user = User.create!(email: 'jim@bob.com', password: 'Pa12341234')
    end

    it "can format events to ics" do
      event = Event.create!(
          name: "Meetup",
          location: "Pepsi Center",
          city: "Denver",
          date: Date.parse('2014-06-20'),
          description: "This is a description",
          capacity: 1,
          category: "test",
          start_time: "19:00",
          end_time: "20:00"
      )

      event2 = Event.create!(
          name: "Test Meetup",
          location: "Galvanize",
          city: "Boulder",
          date: Date.parse('2014-06-20'),
          description: "This is a description",
          capacity: 1,
          category: "test",
          start_time: "19:00",
          end_time: "20:00"
      )

      Registration.create!(event: event, user: @user, role: :guest)
      Registration.create!(event: event2, user: @user, role: :guest)

      timestamp = Time.now.strftime("%Y%m%dT%H%M%SZ")

      expected = <<-INPUT.strip
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//hacksw/handcal//NONSGML v1.0//EN
X-WR-CALNAME:G2 Events Manager Calendar
BEGIN:VEVENT
UID:#{event.id}
DTSTAMP:#{timestamp}
DTSTART:20140620T190000Z
DTEND:20140620T200000Z
SUMMARY:#{event.name} - guest
DESCRIPTION:This is a description
LOCATION:Pepsi Center, Denver
END:VEVENT
BEGIN:VEVENT
UID:#{event2.id}
DTSTAMP:#{timestamp}
DTSTART:20140620T190000Z
DTEND:20140620T200000Z
SUMMARY:#{event2.name} - guest
DESCRIPTION:This is a description
LOCATION:Galvanize, Boulder
END:VEVENT
END:VCALENDAR
      INPUT

      all_events = @user.attended_events

      expect(Event.to_ics(all_events, @user)).to eq expected
    end

    it 'should be able to create an event that starts at midnight or after 12PM' do
      event = Event.create!(
          name: "Meetup",
          location: "Pepsi Center",
          city: "Denver",
          date: Date.parse('2014-06-20'),
          description: "This is a description",
          capacity: 1,
          category: "test",
          start_time: "19:00",
          end_time: "20:00"
      )

      event2 = Event.create!(
          name: "Meetup",
          location: "Pepsi Center",
          city: "Denver",
          date: Date.parse('2014-06-20'),
          description: "This is a description",
          capacity: 1,
          category: "test",
          start_time: "00:00",
          end_time: "01:00"
      )

      Registration.create!(event: event, user: @user, role: :guest)
      Registration.create!(event: event2, user: @user, role: :guest)

      timestamp = Time.now.strftime("%Y%m%dT%H%M%SZ")

      expected = <<-INPUT.strip
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//hacksw/handcal//NONSGML v1.0//EN
X-WR-CALNAME:G2 Events Manager Calendar
BEGIN:VEVENT
UID:#{event.id}
DTSTAMP:#{timestamp}
DTSTART:20140620T190000Z
DTEND:20140620T200000Z
SUMMARY:#{event.name} - guest
DESCRIPTION:This is a description
LOCATION:Pepsi Center, Denver
END:VEVENT
BEGIN:VEVENT
UID:#{event2.id}
DTSTAMP:#{timestamp}
DTSTART:20140620T000000Z
DTEND:20140620T010000Z
SUMMARY:#{event2.name} - guest
DESCRIPTION:This is a description
LOCATION:Pepsi Center, Denver
END:VEVENT
END:VCALENDAR
      INPUT

      all_events = @user.attended_events

      expect(Event.to_ics(all_events, @user)).to eq expected
    end
  end
end