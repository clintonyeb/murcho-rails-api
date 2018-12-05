class AddDefaultToBooleanEvents < ActiveRecord::Migration[5.2]
  def change
    remove_column :event_schemas, :is_all_day, :boolean
    remove_column :event_schemas, :is_recurring, :boolean
    remove_column :event_instances, :is_all_day, :boolean

    add_column :event_schemas, :is_all_day, :boolean, default: false
    add_column :event_schemas, :is_recurring, :boolean, default: false
    add_column :event_instances, :is_all_day, :boolean, default: false
  end
end
