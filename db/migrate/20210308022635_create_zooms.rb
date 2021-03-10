class CreateZooms < ActiveRecord::Migration[6.1]
  def change
    create_table :zooms do |t|
      t.text :host_url
      t.text :join_url
      t.integer :user_id
      t.text :title
      t.text :description

      t.timestamps
    end
  end
end
