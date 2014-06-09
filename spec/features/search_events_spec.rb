require 'spec_helper'

feature 'user can search events' do
  it 'user can enter a city in a search box and see all events in that city' do
    user_register
    click_on 'Add Event'
    fill_in 'Name', with: 'Boulder Event'
    page.find('#event_date').set(1.days.from_now)
    fill_in 'Description', with: 'Awesomeness'
    fill_in 'Location', with: 'Boulder Theatre'
    fill_in 'City', with: 'Boulder'
    fill_in 'Capacity', with: 500
    fill_in 'Category', with: 'Boulder Startup Week'
    click_on 'Create Event'

    click_on 'Add Event'
    fill_in 'Name', with: 'Denver Event'
    page.find('#event_date').set(1.days.from_now)
    fill_in 'Description', with: 'Denver Awesomeness'
    fill_in 'Location', with: 'Galvanize'
    fill_in 'City', with: 'Denver'
    fill_in 'Capacity', with: 500
    fill_in 'Category', with: 'Denver Startup Week'
    click_on 'Create Event'

    visit ('/')
    fill_in 'Search', with: 'Denver'
    click_on 'Search'
    expect(page).to have_content "Denver"
    expect(page).to_not have_content "Boulder"

  end

  it 'user can enter a city with mixed case letters in a search box and see all events in that city' do
    user_register
    click_on 'Add Event'
    fill_in 'Name', with: 'Boulder Event'
    page.find('#event_date').set(1.days.from_now)
    fill_in 'Description', with: 'Awesomeness'
    fill_in 'Location', with: 'Boulder Theatre'
    fill_in 'City', with: 'Boulder'
    fill_in 'Capacity', with: 500
    fill_in 'Category', with: 'Boulder Startup Week'
    click_on 'Create Event'

    click_on 'Add Event'
    fill_in 'Name', with: 'Denver Event'
    page.find('#event_date').set(1.days.from_now)
    fill_in 'Description', with: 'Denver Awesomeness'
    fill_in 'Location', with: 'Galvanize'
    fill_in 'City', with: 'Denver'
    fill_in 'Capacity', with: 500
    fill_in 'Category', with: 'Denver Startup Week'
    click_on 'Create Event'

    visit ('/')
    fill_in 'Search', with: 'dEnVer'
    click_on 'Search'
    expect(page).to have_content "Denver"
    expect(page).to_not have_content "Boulder"

  end

  it 'displays a message when search results brings up nothing' do
    visit ('/')
    fill_in 'Search', with: 'Denver'
    click_on 'Search'

    expect(page).to have_content "Your search for Denver did not return any results."
  end
end