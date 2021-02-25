class AddColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :grade, :integer
    add_column :users, :gender, :integer  #enumで定義
    add_column :users, :faculty, :integer  #enumで定義
  end
end
