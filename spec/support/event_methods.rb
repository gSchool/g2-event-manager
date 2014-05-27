module EventMethods

  def new_event(name="Ignite Boulder")
    click_on 'See All Events'
    click_on 'Add Event'
    fill_in 'Name', with: name
    page.find('#event_date').set(1.days.from_now)
    fill_in 'Description', with: 'Awesomeness'
    fill_in 'Location', with: 'Boulder Theatre'
    fill_in 'Capacity', with: 500
    fill_in 'Category', with: 'Boulder Startup Week'
    click_on 'Create Event'

  end
end