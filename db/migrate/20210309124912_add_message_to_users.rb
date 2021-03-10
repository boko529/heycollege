class AddMessageToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :message, :text
  end
end
