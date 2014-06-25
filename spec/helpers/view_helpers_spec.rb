require 'spec_helper'

describe ViewHelpers do

  it 'can format time from military time to a 12 hour clock' do
    expect(time_to_12_hour("01:00")).to eq "1am"
    expect(time_to_12_hour("00:00")).to eq "12am"
    expect(time_to_12_hour("14:00")).to eq "2pm"
  end

end