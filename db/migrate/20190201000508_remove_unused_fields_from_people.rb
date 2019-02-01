class RemoveUnusedFieldsFromPeople < ActiveRecord::Migration[5.2]
  def change
    remove_column :people, :photo, :string
    remove_column :people, :phone_number, :string
    remove_column :people, :email, :string
  end
end
