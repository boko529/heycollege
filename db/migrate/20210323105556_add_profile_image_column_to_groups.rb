class AddProfileImageColumnToGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :profile_image, :string
  end
end
