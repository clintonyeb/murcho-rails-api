class EventException < ApplicationRecord
  belongs_to :event_schema
  validates :exception_date, :start_date, :end_date, :status, presence: true
  validates :event_schema_id, uniqueness: { scope: :exception_date }
  enum status: [:rescheduled, :cancelled]
end
