class AddIsPublicToZoom < ActiveRecord::Migration[6.1]
  def change
    add_column :zooms, :is_public, :boolean, default: false
  end
end
