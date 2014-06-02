require "spec_helper"

describe UserMailer do
  it "sends forgotten password email" do
    email = UserMailer.forgot_password('me@example.com', 'google.com').deliver
    expect(email.from).to eq ['info@example.com']
    expect(email.to).to eq ['me@example.com']
    expect(email.subject).to eq 'Password reset'
    expect(email.body).to have_content 'Click here to reset password'
    expect(ActionMailer::Base.deliveries.size).to eq(1)
  end
end
