class CreateEventGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :event_groups do |t|
      t.references :event_schema, foreign_key: true
      t.references :group, foreign_key: true

      t.timestamps
    end
  end
end
