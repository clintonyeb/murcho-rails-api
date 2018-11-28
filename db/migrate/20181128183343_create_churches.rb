class CreateChurches < ActiveRecord::Migration[5.2]
  def change
    create_table :churches do |t|
      t.string :name
      t.string :location
      t.string :photo
      t.string :motto
      t.boolean :trash, default: false

      t.timestamps
    end
  end
end
