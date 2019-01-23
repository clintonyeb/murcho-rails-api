class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :actions, :type, :action_type
  end
end
