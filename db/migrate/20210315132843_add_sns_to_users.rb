class AddSnsToUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :twitter_url, :string
    add_column :users, :twitter_name, :string
    add_column :users, :instagram_name, :string
  end
end
