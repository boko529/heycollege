class AddZoomUrlToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :zoom_url, :string
  end
end
