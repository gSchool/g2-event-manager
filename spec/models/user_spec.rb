require 'spec_helper'

describe User do
  it "ensures password is not blank" do
    user = User.new(email: 'bob@bob.com', password: '', password_confirmation: 'nomatch')
    expect(user.save).to eq false
  end
end