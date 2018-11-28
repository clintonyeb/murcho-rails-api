class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :photo
      t.string :phone_number
      t.string :email
      t.integer :access_level
      t.bigint :church_id
      t.string :password_digest
      t.string :salt
      t.string :full_name
      t.boolean :trash, default: false

      t.timestamps
    end
  end
end
