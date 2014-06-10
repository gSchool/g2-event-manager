require 'spec_helper'


feature 'personalized event calendar' do
  scenario 'users get a unique calendar token' do
    visit '/'
    user_calendar_token = SecureRandom.uuid
    user = User.create!(email: 'user@example.com', password: 'Password1', email_confirmed: true, calendar_token: user_calendar_token)
    user_login(user.email, user.password)

    click_on "My Events"

    expect(page).to have_content user_calendar_token
  end
end