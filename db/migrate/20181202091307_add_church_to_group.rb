class AddChurchToGroup < ActiveRecord::Migration[5.2]
  def change
    add_reference :groups, :church, foreign_key: true
  end
end
