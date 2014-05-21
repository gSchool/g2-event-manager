require 'faker'

8.times do
  User.create(
    email: Faker::Internet.safe_email,
    password: Faker::Internet.password(8)
  )
end

25.times do
  Event.create(
    name: "#{Faker::Lorem.word.capitalize} Meetup",
    location: Faker::Address.city,
    date: rand(25).days.from_now,
    description: Faker::Company.catch_phrase,
    capacity: rand(30)+10,
    category: Faker::Commerce.department,
    user_id: rand(8)
  )
end