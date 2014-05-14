require 'spec_helper'

feature 'homepage' do

  it 'have the name of the app' do
    visit '/'
    expect(page).to have_content "EventLite"
  end

end