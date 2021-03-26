class CreateAutoCreates < ActiveRecord::Migration[6.1]
  def change
    create_table :auto_creates do |t|
      t.string :name

      t.timestamps
    end
  end
end
