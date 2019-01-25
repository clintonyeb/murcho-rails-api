class SMSService
  # create a queue that sends a number of available messages per second
  
  def self.send_sms(to, body)
    @client ||= setup
    begin
      @client.api.account.messages.create(
        from: @sender_id,
        to: to,
        body: body
      )
    rescue Twilio::REST::RestError => error
      if error.code == 21612
        @client.messages.create(
          from: @phone_number,
          to:   to,
          body: body
        )
      else
        raise error
      end
    end
  end

  private

  def self.setup
    account_sid = Rails.application.secrets.TWILIO_SID
    auth_token = Rails.application.secrets.TWILIO_AUTH_TOKEN

    # puts account_sid

    @phone_number = Rails.application.secrets.TWILIO_PHONE_NUMBER
    @sender_id = Rails.application.secrets.TWILIO_ALPHANUMERIC_ID
    @client = Twilio::REST::Client.new account_sid, auth_token
  end
end
