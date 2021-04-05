class CreateSlideContents < ActiveRecord::Migration[6.1]
  def change
    create_table :slide_contents do |t|
      t.string :slide_image, null: false
      t.string :link
      t.references :university, null: false, foreign_key: true

      t.timestamps
    end
  end
end
