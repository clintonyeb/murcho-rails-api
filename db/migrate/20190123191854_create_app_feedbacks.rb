class CreateAppFeedbacks < ActiveRecord::Migration[5.2]
  def change
    create_table :app_feedbacks do |t|
      t.string :email

      t.timestamps
    end
  end
end
