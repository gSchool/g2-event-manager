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
      category: "test"
    )
    Attendance.create!(event: @event, user: user, role: :guest)
  end

  it "can return the number of attendees for a given event" do
    actual = @event.number_of_attendees
    expected = 1
    expect(actual).to eq expected
  end

  it "returns number of tickets remaining" do
    actual = @event.tickets_remaining
    expected = 0
    expect(actual).to eq expected
  end
end