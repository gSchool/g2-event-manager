require 'spec_helper'

describe Registration do
  it 'can filter by attendance type' do
    event_i_own = Event.create!
    event_i_attend = Event.create!
    event_i_created = Event.create!
    user = User.create!(email: 't@t.com', password: 'gSchool123')
    Registration.create!(event: event_i_created, user: user, role: :creator)
    Registration.create!(event: event_i_attend, user: user, role: :guest)
    Registration.create!(event: event_i_own, user: user, role: :admin)
    expect(user.created_events.length).to eq(1)
    expect(user.created_events).to include(event_i_created)
    expect(user.attended_events.length).to eq(1)
    expect(user.attended_events).to include(event_i_attend)
    expect(user.owned_events.length).to eq(1)
    expect(user.owned_events).to include(event_i_own)
  end

  it 'user can register then unregister for an event ' do
    user = create_user
    event = create_event
    register_user_for_event(user, event)
    expected = user.registrations
    expect(user.id).to eq expected.first.user_id
    expect(event.id).to eq expected.first.event_id
    unregister_user_for_event(user, event)
    expect(user.registrations).to be_empty
  end
end