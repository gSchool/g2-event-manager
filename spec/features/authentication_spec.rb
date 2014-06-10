require 'spec_helper'

feature "User can register, logout & login for the site" do
  scenario "user registers and confirms their email address and logs in" do
    mail_sent = ActionMailer::Base.deliveries.length

    visit '/'
    click_on 'Register'
    fill_in 'user[email]', with: "joesmith@example.com"
    fill_in 'user[password]', with: "Gschool123"
    fill_in 'user[password_confirmation]', with: "Gschool123"
    click_on 'Submit'

    expect(ActionMailer::Base.deliveries.length).to eq (mail_sent + 1)
    expect(page).to have_content 'A confirmation email has been sent to your email address'

    #user must first confirm their email address
    visit '/'

    click_link 'Login'

    fill_in 'Email', with: "joesmith@example.com"
    fill_in 'Password', with: "Gschool123"
    click_button 'Submit'

    expect(page).to have_content "Your email address has not been confirmed"

    #user confirms their email address
    email_body = ActionMailer::Base.deliveries.last.body.raw_source
    @document = Nokogiri::HTML(email_body)
    result = @document.xpath("//html//body//a//@href")[0].value

    expect(result).to include('http://')

    visit result

    expect(page).to have_content "Email confirmed, you can now login"

    visit '/'

    click_link 'Login'

    fill_in 'Email', with: "joesmith@example.com"
    fill_in 'Password', with: "Gschool123"
    click_button 'Submit'

    expect(page).to have_content "joesmith@example.com"
    expect(page).to have_link 'Logout'
  end

  scenario "User cannot login with incorrect password" do
    user = User.create!(email: 'joesmith@example.com', password: 'Password1')

    visit '/'
    click_link 'Login'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: "WrongPassword1"
    click_button 'Submit'

    expect(page).to have_content 'User/Password Combination is not correct'
  end

end