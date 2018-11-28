class CreatePersonProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :person_profiles do |t|
      t.date :date_of_birth
      t.integer :relation_status
      t.integer :gender
      t.references :person, foreign_key: true
      t.string :address
      t.string :profession

      t.timestamps
    end
  end
end
