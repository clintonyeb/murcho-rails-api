class EventGroup < ApplicationRecord
  belongs_to :event_schema
  belongs_to :group

  validates :event_schema, presence: true
  validates :group_id, presence: true

  validates :event_schema, uniqueness: { scope: :group_id }
end
