class CreateApuLectures < ActiveRecord::Migration[6.1]
  def change
    create_table :apu_lectures do |t|

      t.timestamps
    end
  end
end
