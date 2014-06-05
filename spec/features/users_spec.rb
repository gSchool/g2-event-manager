require 'spec_helper'

feature 'Users' do
  scenario 'can log in and manage events' do
    user_register
    new_event
    expect(page).to have_content 'Ignite Boulder'
    click_on 'Edit this Event'
    fill_in 'Location', with: 'Fox Theatre'
    click_on 'Update Event'
    expect(page).to have_content 'Fox Theatre'
    expect(page).to_not have_content 'Boulder Theatre'
    click_on 'Delete this Event'
    expect(page).to_not have_content 'Ignite Boulder'
  end

  scenario 'Registered user can see all the events they signed up for' do
    user_register
    new_event
    click_on 'Logout'
    user_register("s@s.com")

    click_on 'Ignite Boulder'
    click_on 'RSVP for this Event'
    click_on 'My Events'
    expect(page).to have_content 's@s.com'

    within '#attending' do
      expect(page).to have_content 'Ignite Boulder'
    end
  end

  scenario 'user can reset their password' do
    user = User.create!(email: 'user@example.com', password: 'Password1', email_confirmed: true)
    mail_sent = ActionMailer::Base.deliveries.length

    visit '/'

    click_link 'Login'
    click_link 'Forgot password?'

    fill_in 'Email', with: user.email
    click_button 'Reset Password'

    expect(ActionMailer::Base.deliveries.length).to eq (mail_sent + 1)
    expect(page).to have_content 'An email has been sent with instructions on how to reset your password'

    user.reload

    time_sent = user.password_reset_sent_at

    email_body = ActionMailer::Base.deliveries.last.body.raw_source
    @document = Nokogiri::HTML(email_body)
    result = @document.xpath("//html//body//a//@href")[0].value

    new_time = time_sent + 14.minutes
    Timecop.travel(new_time)

    visit result

    fill_in 'Password', with: 'Password2'
    fill_in 'Password confirmation', with: 'Password2'
    click_on 'Update Password'

    expect(page).to have_content "Password Updated"

    visit '/'

    click_link 'Login'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'Password2'
    click_button 'Submit'

    expect(page).to have_content user.email
    expect(page).to have_link 'Logout'
  end

  scenario 'user cannot reset their password after the token expires' do
    user = User.create!(email: 'user@example.com', password: 'Password1')
    mail_sent = ActionMailer::Base.deliveries.length

    visit '/'

    click_link 'Login'
    click_link 'Forgot password?'

    fill_in 'Email', with: user.email
    click_button 'Reset Password'

    expect(ActionMailer::Base.deliveries.length).to eq (mail_sent + 1)
    expect(page).to have_content 'An email has been sent with instructions on how to reset your password'

    user.reload

    time_sent = user.password_reset_sent_at

    email_body = ActionMailer::Base.deliveries.last.body.raw_source
    @document = Nokogiri::HTML(email_body)
    result = @document.xpath("//html//body//a//@href")[0].value

    new_time = time_sent + 16.minutes
    Timecop.travel(new_time)

    visit result

    fill_in 'Password', with: 'Password2'
    fill_in 'Password confirmation', with: 'Password2'
    click_on 'Update Password'

    expect(page).to have_content "Token has expired. Click Forgot password? for another email. Please note, the reset password length is only active for 15 minutes."
  end
end