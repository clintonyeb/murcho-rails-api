ActionMailer::Base.add_delivery_method :ses, AWS::SES::Base,
  access_key_id:      Rails.application.secrets.AWS_ACCESS_KEY_ID,
  secret_access_key:  Rails.application.secrets.AWS_SECRET_ACCESS_KEY,
  region:             Rails.application.secrets.AWS_REGION