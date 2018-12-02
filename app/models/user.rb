class User < ApplicationRecord
  has_secure_password

  # Validations
  validates :email, :phone_number, :access_level, :church_id, :full_name, :access_level, :salt, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :email, format: {with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, message: "Please provide a valid email address."}

  # Enums
  
  enum access_level: [:super_admin, :admin, :user, :guest]
  after_initialize :set_salt, :if => :new_record?

  def set_salt
    self.salt ||= BCrypt::Engine.generate_salt
  end

end
