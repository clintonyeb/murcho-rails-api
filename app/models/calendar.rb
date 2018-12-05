class Calendar < ApplicationRecord
  belongs_to :church
  validates :name, presence: true
end
