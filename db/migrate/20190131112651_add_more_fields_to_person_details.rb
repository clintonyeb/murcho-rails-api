class AddMoreFieldsToPersonDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :person_details, :date_of_baptism, :date
    add_column :person_details, :place_of_baptism, :string
    add_column :person_details, :pastor_or_ministry, :string
    add_column :person_details, :confirmation_date, :date
    add_column :person_details, :place_of_confirmation, :string
    add_column :person_details, :communicant_status, :boolean
    add_column :person_details, :generational_group, :string
    add_column :person_details, :interest_group, :string
    add_column :person_details, :special_interests, :string
    add_column :person_details, :position_in_church, :string
    add_column :person_details, :church_position_period, :string
  end
end
