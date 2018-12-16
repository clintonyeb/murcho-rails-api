class AddStartDateToEventException < ActiveRecord::Migration[5.2]
  def change
    add_column :event_exceptions, :start_date, :datetime
  end
end
