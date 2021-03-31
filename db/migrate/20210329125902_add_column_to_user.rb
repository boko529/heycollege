class AddColumnToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :type, :string, default: Apu::User, null: false
  end
end
