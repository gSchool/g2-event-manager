require 'spec_helper'

describe User do
  it "ensures password is not blank" do
    user = User.new(email: 'bob@bob.com', password: 'Password1', password_confirmation: 'Password1', email_confirmed: true)
    expect(user.valid?).to eq true

    user = User.new(email: 'bob@bob.com', password: '', password_confirmation: '', email_confirmed: true)

    expect(user.valid?).to eq false
  end
  it "ensures password is in proper format" do
    user = User.new(email: 'bob@bob.com', password: 'Password1', password_confirmation: 'Password1', email_confirmed: true)
    expect(user.valid?).to eq true

    user.password = "short"
    expect(user.valid?).to eq false
  end


  it "ensures email is not blank" do
    user = User.new(email: 'bob@bob.com', password: 'Password1', password_confirmation: 'Password1', email_confirmed: true)
    expect(user.valid?).to eq true

    user.email = ""
    expect(user.valid?).to eq false

  end

  it "ensures email is unique" do
    user = User.create!(email: 'bob@bob.com', password: 'Password1', password_confirmation: 'Password1', email_confirmed: true)
    expect(user.valid?).to eq true

    user2 = User.new(email: 'bob@bob.com', password: 'Password1', password_confirmation: 'Password1', email_confirmed: true)
    expect(user2.valid?).to eq false

  end

  it "ensures email does not have an invalid format" do
    user = User.new(email: 'bob@bob.com', password: 'Password1', password_confirmation: 'Password1', email_confirmed: true)
    expect(user.valid?).to eq true

    user.email = "bob"
    expect(user.valid?).to eq false

  end
end
