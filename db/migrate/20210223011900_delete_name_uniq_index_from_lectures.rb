class DeleteNameUniqIndexFromLectures < ActiveRecord::Migration[6.1]
  # nameのunique: trueを消してます。
  def change
    remove_index :lectures, :name
    add_index :lectures, :name
  end
end
