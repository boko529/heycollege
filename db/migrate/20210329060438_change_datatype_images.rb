class ChangeDatatypeImages < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :image
    remove_column :groups, :header_image
    remove_column :groups, :profile_image
    add_column :users, :image, :string
    add_column :groups, :header_image, :string
    add_column :groups, :profile_image, :string
  end
end
