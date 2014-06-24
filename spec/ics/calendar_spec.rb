require 'spec_helper'

describe "GET /users/calendar/:calendar_token.ics", type: :request do

  it 'returns a list of events in ics format' do
    user = User.create!(email: 'user@example.com', password: 'Password1', email_confirmed: true, calendar_token: SecureRandom.uuid)
    event = Event.create!(
      name: "#{Faker::Lorem.word.capitalize} Meetup",
      location: "Place",
      city: Faker::Address.city,
      date: Date.parse('2014-06-20'),
      description: Faker::Company.catch_phrase,
      capacity: rand(30)+10,
      category: Faker::Commerce.department,
      start_time: "07:00",
      end_time: "08:00"
    )

    Registration.create!(event: event, user: user, role: :admin)

    timestamp = Time.now.strftime("%Y%m%dT%H%M%SZ")

    get "/users/calendar/#{user.calendar_token}.ics", {}, {'Accept' => 'text/html'}

    expected = <<-INPUT.strip
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//hacksw/handcal//NONSGML v1.0//EN
BEGIN:VEVENT
UID:#{event.id}
DTSTAMP:#{timestamp}
DTSTART:20140620T190000Z
DTEND:20140620T200000Z
SUMMARY:#{event.name} - admin
DESCRIPTION:#{event.description}
LOCATION:#{event.location}, #{event.city}
END:VEVENT
END:VCALENDAR
    INPUT

    expect(response.code.to_i).to eq 200
    expect(response.body).to eq expected
  end
end