class EventException < ApplicationRecord
  belongs_to :event_schema

  enum status: [:rescheduled, :cancelled]
end
