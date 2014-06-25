require 'twilio-ruby'

class TwilioController < ApplicationController
  include Webhookable

  after_filter :set_header

  skip_before_action :verify_authenticity_token

  def outbound_sms
    @client = Twilio::REST::Client.new ENV['SID'], ENV['AUTH_TOKEN']
    message = @client.account.messages.create(:body => "Your event starts in 20 minutes.", :to => ENV["INBOUND_PHONE_NUMBER"], :from => ENV["OUTBOUND_PHONE_NUMBER"])
    puts message.to

  end

end


