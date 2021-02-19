class CreateHelpfuls < ActiveRecord::Migration[6.1]
  def change
    create_table :helpfuls do |t|
      t.integer :review_id
      t.integer :user_id

      t.timestamps
      t.index [:user_id, :review_id], unique: true
    end
  end
end
