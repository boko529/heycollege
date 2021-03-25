class AddProfileToGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :profile, :text
  end
end
