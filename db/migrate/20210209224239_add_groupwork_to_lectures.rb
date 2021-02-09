class AddGroupworkToLectures < ActiveRecord::Migration[6.1]
  def change
    add_column :lectures, :group_work, :integer
  end
end
