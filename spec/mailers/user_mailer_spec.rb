require "spec_helper"

describe UserMailer do
  it "sends forgotten password email" do
    token = SecureRandom.uuid
    user = User.new(email: 'me@example.com', password: 'Password1')
    email = UserMailer.forgot_password(user, token).deliver
    expect(email.from).to eq ['info@example.com']
    expect(email.to).to eq ['me@example.com']
    expect(email.subject).to eq 'Password reset'
    expect(email.body).to have_content 'Click here to reset password'
  end
end
