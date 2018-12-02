class Group < ApplicationRecord
  has_many :people, through: :person_groups
end
