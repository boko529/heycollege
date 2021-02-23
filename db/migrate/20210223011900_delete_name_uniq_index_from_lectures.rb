class DeleteNameUniqIndexFromLectures < ActiveRecord::Migration[6.1]
  def change
    remove_index :lectures, :name
    add_index :lectures, :name
  end
end
