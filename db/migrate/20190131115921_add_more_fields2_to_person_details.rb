class AddMoreFields2ToPersonDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :person_details, :name_of_mother, :string
    add_column :person_details, :name_of_father, :string
    add_column :person_details, :marital_status, :string
    add_column :person_details, :name_of_spouse, :string
    add_column :person_details, :spouse_contact, :string
    add_column :person_details, :names_of_children, :string
  end
end
