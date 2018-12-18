class AddHeadChurchToChurch < ActiveRecord::Migration[5.2]
  def change
    add_reference :churches, :head_office, index: true
  end
end
