class Person < ApplicationRecord
  belongs_to :church
  has_many :person_groups, dependent: :delete_all
  has_many :groups, through: :person_groups
  has_one :person_details, dependent: :delete
  
  before_create :generate_member_id

  validates :church_id, presence: true

  enum rel_status: [:single, :courting, :married, :divorced, :widowed]
  enum membership_status: [:member, :guest, :former]

  def generate_member_id
    self.member_id = SecureRandom.hex(10)
  end
end
