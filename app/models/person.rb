class Person < ApplicationRecord
  belongs_to :church
  has_many :person_groups, dependent: :delete_all
  has_many :groups, through: :person_groups

  validates :church_id, presence: true

  enum rel_status: [:single, :courting, :married, :divorced, :widowed]
  enum membership_status: [:member, :guest, :former_member]
end
