class EventSchema < ApplicationRecord
  belongs_to :calendar
  has_one :event_schema, foreign_key: :parent_event_schema_id

  validates :title, :start_date, :duration, :end_date, presence: true
  # validates : if is_recurring true: then make sure recurrence is not null
  validates_presence_of :recurrence, :if => :is_recurring?

  # Basic unit of duration is in seconds

  enum color: [:blue, :green, :yellow, :purple, :red]
end
