class User < ApplicationRecord
  has_secure_password

  # Callbacks
  before_create :generate_email_confirmation

  # Validations
  validates :email, :access_level, :church_id, :salt, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :email, format: {with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, message: "Please provide a valid email address."}

  # Enums
  
  enum access_level: [:super_admin, :admin, :user, :guest]
  after_initialize :set_salt, :if => :new_record?

  def set_salt
    self.salt ||= BCrypt::Engine.generate_salt
  end

  def generate_email_confirmation
    self.email_confirmed_token = SecureRandom.hex(10)
    self.email_confirmed_sent_at = Time.now.utc
  end

  def confirmation_token_valid?
    (self.email_confirmed_sent_at + 30.days) > Time.now.utc
  end

  def mark_as_confirmed!
    self.email_confirmed_token = nil
    self.email_confrimed_at = Time.now.utc
    self.email_confirmed = true
    save
  end

  def generate_password_token!
    self.reset_password_token = SecureRandom.hex(10)
    self.reset_password_created_at = Time.now.utc
    save!
  end

  def password_token_valid?
    (self.reset_password_created_at + 4.hours) > Time.now.utc
  end
  
  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    save!
  end

end
