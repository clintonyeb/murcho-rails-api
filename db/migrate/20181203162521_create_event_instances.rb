class CreateEventInstances < ActiveRecord::Migration[5.2]
  def change
    create_table :event_instances do |t|
      t.string :title
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :is_all_day
      t.integer :duration
      t.string :location
      t.references :calendar, foreign_key: true
      t.bigint :event_schema_id

      t.timestamps
    end
  end
end
