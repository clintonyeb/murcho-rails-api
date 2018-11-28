class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :photo
      t.string :phone_number
      t.string :email
      t.integer :membership_status
      t.references :church, foreign_key: true
      t.boolean :trash, default: false
      t.date :date_joined

      t.timestamps
    end
  end
end
