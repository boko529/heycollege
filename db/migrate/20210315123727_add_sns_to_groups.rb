class AddSnsToGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :instagram_name, :string
    add_column :groups, :twitter_name, :string
  end
end
