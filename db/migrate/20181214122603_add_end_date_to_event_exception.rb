class AddEndDateToEventException < ActiveRecord::Migration[5.2]
  def change
    add_column :event_exceptions, :end_date, :datetime
  end
end
