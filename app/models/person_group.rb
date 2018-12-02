class PersonGroup < ApplicationRecord
  belongs_to :person
  belongs_to :group

  validates :person_id, presence: true
  validates :group_id, presence: true

  validates :person_id, uniqueness: { scope: :group_id }
end
