class AddStatusToLectures < ActiveRecord::Migration[6.1]
  def change
    add_column :lectures, :state, :integer
    add_index :lectures, :state
  end
end
