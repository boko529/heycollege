class RemoveTitleFromReviews < ActiveRecord::Migration[6.1]
  def change
    remove_column :reviews, :title, :string
  end
end
