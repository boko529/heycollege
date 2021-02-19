class AddColumnReviews < ActiveRecord::Migration[6.1]
  def change
    add_column :reviews, :difficulty, :float
  end
end
