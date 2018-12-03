class CreateEventExceptions < ActiveRecord::Migration[5.2]
  def change
    create_table :event_exceptions do |t|
      t.references :event_schema, foreign_key: true
      t.datetime :exception_date
      t.integer :status

      t.timestamps
    end
  end
end
