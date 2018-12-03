class CreateCalendars < ActiveRecord::Migration[5.2]
  def change
    create_table :calendars do |t|
      t.references :church, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
