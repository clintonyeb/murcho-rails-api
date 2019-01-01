class UpdateEventException < ActiveRecord::Migration[5.2]
  def change
    remove_column :event_exceptions, :color, :boolean
  end
end
