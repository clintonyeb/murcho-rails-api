class SMSService
  # create a queue that sends a number of available messages per second
  
  def self.send_sms(to, body)
    @client ||= setup

    @client.api.account.messages.create(
      from: @phone_number,
      to: to,
      body: body
    )
  end

  private

  def self.setup
    account_sid = Rails.application.secrets.TWILIO_SID
    auth_token = Rails.application.secrets.TWILIO_AUTH_TOKEN

    # puts account_sid

    @phone_number = Rails.application.secrets.TWILIO_PHONE_NUMBER
    @client = Twilio::REST::Client.new account_sid, auth_token
  end
end
