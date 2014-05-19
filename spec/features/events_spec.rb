require 'spec_helper'

feature 'events managment' do

  before do
    visit '/'
    click_on 'Register'
    fill_in 'Email', with: 's@s.com'
    fill_in 'Password', with: 'password'
    click_on 'Submit'
    click_on 'See All Events'
    click_on 'Add Event'
    fill_in 'Name', with: 'Ignite Boulder'
    page.find('#event_date').set('2014-05-15')
    fill_in 'Description', with: 'Awesomeness'
    fill_in 'Location', with: 'Boulder Theatre'
    fill_in 'Capacity', with: 500
    fill_in 'Category', with: 'Boulder Startup Week'
    click_on 'Create Event'
    user = User.last
    15.times do
      Event.create(name: 'things')
    end
  end

  scenario 'only a user can add an event' do

    expect(page).to have_content 'Ignite Boulder'
    expect(page).to have_content '2014-05-15'
    expect(page).to have_content 'Boulder Theatre'
  end

  scenario 'user can click on event to see details' do
    click_on 'Ignite Boulder'
    expect(page).to have_content 'Ignite Boulder'
    expect(page).to have_content '2014-05-15'
    expect(page).to have_content 'Boulder Theatre'
    expect(page).to have_content 'Awesomeness'
    expect(page).to have_content 'Boulder Startup Week'
    expect(page).to have_content '500'
  end

  scenario 'Guests cannot create an event' do
    click_on 'Logout'
    click_on 'See All Events'
    click_on 'Add Event'
    expect(page).to have_content('You must login to create an event')
  end

  scenario 'there are only 10 events per page' do
    visit '/events'
    expect(page).to have_link '2'
  end

end