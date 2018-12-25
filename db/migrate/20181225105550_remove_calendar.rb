class RemoveCalendar < ActiveRecord::Migration[5.2]
  def change
    remove_reference :event_schemas, :calendar, index: true, foreign_key: true
    drop_table :calendars
    add_reference :event_schemas, :church, index: true
  end
end
