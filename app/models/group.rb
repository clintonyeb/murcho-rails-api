class Group < ApplicationRecord
  has_many :person_groups
  has_many :people, through: :person_groups
end
