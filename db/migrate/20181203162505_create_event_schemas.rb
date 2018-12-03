class CreateEventSchemas < ActiveRecord::Migration[5.2]
  def change
    create_table :event_schemas do |t|
      t.string :title
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :is_all_day
      t.boolean :is_recurring
      t.string :recurrence
      t.integer :duration
      t.string :location
      t.references :calendar, foreign_key: true

      t.timestamps
    end
  end
end
