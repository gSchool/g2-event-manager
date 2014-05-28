require 'spec_helper'

describe User do
  it "ensures password is not blank" do
    user = User.new(email: 'bob@bob.com', password: '', password_confirmation: 'nomatch')
    expect(user.save).to eq false
  end

  it "ensures email is not blank" do
    user = User.new(email: '', password: '1234', password_confirmation: '1234')
    expect(user.save).to eq false
  end

  it "generates a url for a forgotten password" do
    user = User.new(email: 'bob@bob.com', password: 'gSchool12', password_confirmation: 'gSchool12')
    expect(user.token).to eq nil
    user.lost_password
    expect(user.token).to_not eq nil
  end

end