require 'spec_helper'

feature "User can register & login for the site" do
  scenario "user can register" do
    visit '/'
    click_on 'Register'
    fill_in 'user[email]', with: "joesmith@example.com"
    fill_in 'user[password]', with: "1234"
    click_on 'Submit'
    expect(page).to have_content 'joesmith@example.com'
  end
end