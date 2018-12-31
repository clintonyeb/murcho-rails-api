class CreateActions < ActiveRecord::Migration[5.2]
  def change
    create_table :actions do |t|
      t.integer :type
      t.bigint :recipient
      t.integer :status

      t.timestamps
    end
  end
end
