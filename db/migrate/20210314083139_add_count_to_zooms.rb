class AddCountToZooms < ActiveRecord::Migration[6.1]
  def change
    add_column :zooms, :count, :integer, default: 1
  end
end
