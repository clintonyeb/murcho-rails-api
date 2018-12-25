class Church < ApplicationRecord
  has_many :branches, class_name: "Church", foreign_key: "head_office_id"
  belongs_to :head_office, class_name: "Church", optional: true

  validates :name, presence: true
end
