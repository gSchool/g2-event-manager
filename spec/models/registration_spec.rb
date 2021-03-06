require 'spec_helper'

describe Registration do
  it 'can filter by attendance type' do
    event_i_own = Event.create!(name: 'GFY', description: 'Foo', date: 2.months.from_now, location: 'Denver', capacity:1, category: 'Birthday', start_time: "07:00", end_time: "08:00")
    event_i_attend = Event.create!(name: 'FYG', description: 'Bar', date: 2.months.from_now, location: 'Denver', capacity:1, category: 'Birthday', start_time: "07:00", end_time: "08:00")
    event_i_created = Event.create!(name: 'YFG', description: 'Baz', date: 2.months.from_now, location: 'Denver', capacity:1, category: 'Birthday', start_time: "07:00", end_time: "08:00")
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
end