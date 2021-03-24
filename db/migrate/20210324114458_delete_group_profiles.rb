class DeleteGroupProfiles < ActiveRecord::Migration[6.1]
  def change
    drop_table :group_profiles
  end
end
