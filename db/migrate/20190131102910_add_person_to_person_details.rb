class AddPersonToPersonDetails < ActiveRecord::Migration[5.2]
  def change
    add_reference :person_details, :person, foreign_key: true
  end
end
