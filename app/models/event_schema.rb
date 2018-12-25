class EventSchema < ApplicationRecord
  attr_accessor :is_exception

  has_one :event_schema, foreign_key: :parent_event_schema_id
  has_many :event_exceptions, dependent: :delete_all
  has_many :event_groups, dependent: :delete_all

  validates :title, :start_date, :duration, :end_date, presence: true
  # validates : if is_recurring true: then make sure recurrence is not null
  validates_presence_of :recurrence, :if => :is_recurring?

  # Basic unit of duration is in seconds

  enum color: [:blue, :green, :yellow, :purple, :red]

  def attributes
    super.merge('is_exception' => self.is_exception)
  end
end
