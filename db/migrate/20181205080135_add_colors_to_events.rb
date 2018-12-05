class AddColorsToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :event_schemas, :color, :integer, default: 0
    add_column :event_instances, :color, :integer, default: 0
    add_column :event_exceptions, :color, :integer, default: 0
  end
end
