class ChangeColumnToNull < ActiveRecord::Migration[6.1]
  def change
    # not nillを外した。
    remove_column :notifications, :review_id, :integer
    add_column :notifications, :review_id, :integer

    add_index :notifications, :review_id
  end
end
