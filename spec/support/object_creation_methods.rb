require 'faker'
module ObjectCreationMethods
  def create_event
    Event.create!(
      name: "#{Faker::Lorem.word.capitalize} Meetup",
      location: Faker::Address.city,
      date: rand(25).days.from_now,
      description: Faker::Company.catch_phrase,
      capacity: rand(30)+10,
      category: Faker::Commerce.department,
      start_time: "07:00",
      end_time: "08:00"
    )
  end

  def create_user
    User.create(email: "bob@bob.com", password: "gSchool123")
  end

  def create_event_reminder(event_id)
    EventReminder.create!(event_id: event_id)
  end

end