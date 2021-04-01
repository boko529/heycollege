class AddColumnToZooms < ActiveRecord::Migration[6.1]
  def change
    add_column :zooms, :start_time, :datetime
    add_column :zooms, :end_time, :datetime
    add_index :zooms, :start_time
  end
end
