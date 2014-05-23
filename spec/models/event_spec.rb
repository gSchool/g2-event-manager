require 'spec_helper'

describe Event do
  before do
    @user = User.create!(email: 'bob@bob.com', password: '12341234', password_confirmation: '12341234')
    @event = Event.create!(
      name: "Test Meetup",
      location: "Boulder, CO",
      date: 1.days.from_now,
      description: "This is a description",
      capacity: 1,
      category: "test"
    )
  end

  it "can return the number of attendees for a given event" do
    actual = @event.number_of_registrations
    expect(actual).to eq 0

    @event.add_to_guest_list(@user)

    actual = @event.number_of_registrations
    expect(actual).to eq 1
  end

  it "returns number of tickets remaining" do
    actual = @event.tickets_remaining
    expect(actual).to eq 1

    @event.add_to_guest_list(@user)

    actual = @event.tickets_remaining
    expect(actual).to eq 0
  end

  it 'can manage a wait list' do
    expect(@event.waitlist).to_not include @user

    @event.add_to_waitlist(@user)

    expect(@event.waitlist).to include @user

    @event.remove_from_waitlist(@user)

    expect(@event.waitlist).to_not include @user
  end

  it 'can manage a guest list with overflow to a waitlist' do
    expect(@event.guest_list).to_not include @user

    result = @event.add_to_guest_list(@user)

    expect(result).to eq :guest_list
    expect(@event.guest_list).to include @user

    another_user = User.create!(email: 'sue@sue.com', password: '12341234', password_confirmation: '12341234')

    result = @event.add_to_guest_list(another_user)

    expect(result).to_not eq :guest_list
    expect(@event.guest_list.length).to eq 1
    expect(@event.waitlist.length).to eq 1
    expect(@event.waitlist).to include another_user
  end
end