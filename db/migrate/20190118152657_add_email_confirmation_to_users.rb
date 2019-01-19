class AddEmailConfirmationToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :email_confirmed_token, :string
    add_column :users, :email_confirmed, :boolean, default: false
    add_column :users, :email_confrimed_at, :datetime
    add_column :users, :email_confirmed_sent_at, :datetime
  end
end
