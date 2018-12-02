class CreatePersonGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :person_groups do |t|
      t.references :person, foreign_key: true
      t.references :group, foreign_key: true

      t.timestamps
    end
  end
end
