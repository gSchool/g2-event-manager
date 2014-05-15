require 'spec_helper'

feature 'events managment' do

  scenario 'user can add an event' do
    visit '/'
    click_on 'See All Events'
    click_on 'Add Event'
    fill_in 'Name', with: 'Ignite Boulder'
    page.find('#event_date').set('2014-05-15')
    fill_in 'Description', with: 'Awesomeness'
    fill_in 'Location', with: 'Boulder Theatre'
    fill_in 'Capacity', with: 500
    fill_in 'Category', with: 'Boulder Startup Weekup'

    click_on 'Create Event'

    expect(page).to have_content 'Ignite Boulder'
    expect(page).to have_content '2014-05-15'
    expect(page).to have_content 'Awesomeness'
    expect(page).to have_content 'Boulder Theatre'

  end
end