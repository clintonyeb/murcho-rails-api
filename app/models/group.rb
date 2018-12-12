class Group < ApplicationRecord
  belongs_to :church
  has_many :person_groups, dependent: :delete_all
  has_many :people, through: :person_groups

  validates :name, uniqueness: { scope: :church_id }
  validates :church_id, presence: true
end
