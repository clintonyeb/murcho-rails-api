class UpdateEventException < ActiveRecord::Migration[5.2]
  def change
    remove_column :event_exceptions, :color, :boolean
    drop_table :event_instances
  end
end
