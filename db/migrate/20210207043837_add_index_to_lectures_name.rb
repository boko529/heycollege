class AddIndexToLecturesName < ActiveRecord::Migration[6.1]
  def change
    add_index :lectures, :name, unique: true
  end
end
