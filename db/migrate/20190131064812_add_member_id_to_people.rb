class AddMemberIdToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :member_id, :string, unique: true

    Person.find_each do |person|
      person.generate_member_id
      person.save!
    end

    # add NOT NULL constraint
    change_column_null :people, :member_id, false
  end
end
