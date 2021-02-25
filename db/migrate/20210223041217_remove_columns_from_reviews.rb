class RemoveColumnsFromReviews < ActiveRecord::Migration[6.1]
  def change
    remove_column :reviews, :explanation, :float
    remove_column :reviews, :fairness, :float
    remove_column :reviews, :recommendation, :float
    remove_column :reviews, :useful, :float
    remove_column :reviews, :interesting, :float
    remove_column :reviews, :difficulty, :float
    # notnullを追加
    change_column_null :reviews, :score, false
  end
end
