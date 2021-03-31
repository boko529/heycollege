class CreateZooms < ActiveRecord::Migration[6.1]
  def change
    create_table :zooms do |t|
      t.text :join_url
      t.integer :user_id
      t.string :title

      t.timestamps
    end
  end
end
