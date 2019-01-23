class PersonMailer < ApplicationMailer
  include Roadie::Rails::Mailer
  include SendGrid

  def send_mail
    people = Person.where("church_id = ? AND id IN (?) AND email IS NOT NULL", params[:church_id], params[:person_ids]).select(:id, :email) 
  
    count = 0
    people.each do |person|
      @message = params[:message]
      mail(to: person[:email], subject: params[:subject])
      Action.create({
        action_type: :email,
        recipient: person[:id],
        status: :success
      })
      count += 1
    end

    logger.info "Processed #{count} people out of #{params[:person_ids].length}"
    count 

  end

  def send_confirmation_email
    @user = params[:user]
    subject = "Confirm your email - Murcho Platform"
    @root_url = Rails.application.secrets.FRONT_END

    roadie_mail(to: @user[:email], subject: subject)
  end

  def send_password_reset
    @user = params[:user]
    subject = "Reset Your Password - Murcho Platform"
    @root_url = Rails.application.secrets.FRONT_END

    roadie_mail(to: @user[:email], subject: subject)
  end

  def password_reset_confirmation
    @user = params[:user]
    subject = "Password Reset Successful - Murcho Platform"

    roadie_mail(to: @user[:email], subject: subject)
  end

  def send_welcome
    @user = params[:user]
    subject = "Welcome! - Murcho Platform"
    @root_url = Rails.application.secrets.FRONT_END

    roadie_mail(to: @user[:email], subject: subject)
  end
end
