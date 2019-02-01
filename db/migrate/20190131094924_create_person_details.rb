class CreatePersonDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :person_details do |t|
      t.string :other_names
      t.string :date_of_birth
      t.string :place_of_birth
      t.integer :age
      t.string :day_born
      t.integer :gender
      t.string :house_number
      t.string :street_name
      t.string :location
      t.string :hometown
      t.string :hometown_address
      t.string :education_level
      t.string :occupation
      t.string :cell_phone_1
      t.string :cell_phone_2
      t.string :email
      t.string :photo
      t.string :photo

      t.timestamps
    end
  end
end
