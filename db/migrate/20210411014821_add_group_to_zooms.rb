class AddGroupToZooms < ActiveRecord::Migration[6.1]
  def change
    add_column :zooms, :group_id, :integer, :default => 0
  end
end
