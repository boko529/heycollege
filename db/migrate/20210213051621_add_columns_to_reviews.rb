class AddColumnsToReviews < ActiveRecord::Migration[6.1]
  def change
    add_column :reviews, :explanation, :float, null: false
    add_column :reviews, :fairness, :float, null: false
    add_column :reviews, :recommendation, :float, null: false
    add_column :reviews, :useful, :float, null: false
    add_column :reviews, :interesting, :float, null: false
  end
end
