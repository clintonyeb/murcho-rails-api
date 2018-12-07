class AddThumbnailToPerson < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :thumbnail, :string
  end
end
