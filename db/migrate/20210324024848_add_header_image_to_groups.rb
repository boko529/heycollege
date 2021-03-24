class AddHeaderImageToGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :header_image, :string
  end
end
