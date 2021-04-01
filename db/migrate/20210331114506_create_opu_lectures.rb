class CreateOpuLectures < ActiveRecord::Migration[6.1]
  def change
    create_table :opu_lectures do |t|

      t.timestamps
    end
  end
end
