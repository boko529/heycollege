class CreateUserZooms < ActiveRecord::Migration[6.1]
  def change
    create_table :user_zooms do |t|
      t.integer :user_id
      t.integer :zoom_id

      t.timestamps
    end
    add_index :user_zooms, :user_id
    add_index :user_zooms, :zoom_id
    add_index :user_zooms, [:user_id, :zoom_id], unique: true
  end
end
