class Person < ApplicationRecord
  belongs_to :church

  validates :church_id, presence: true

  enum rel_status: [:single, :courting, :married, :divorced, :widowed]
  enum membership_status: [:member, :guest]
end
