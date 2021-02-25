class CreateLectures < ActiveRecord::Migration[6.1]
  def change
    create_table :lectures do |t|
      t.text :name

      t.timestamps
    end
  end
end
