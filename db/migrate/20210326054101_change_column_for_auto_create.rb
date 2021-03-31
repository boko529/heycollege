class ChangeColumnForAutoCreate < ActiveRecord::Migration[6.1]
  def change
    rename_column :lectures, :name, :name_ja
    add_column :lectures, :name_en, :string
    rename_column :teachers, :name, :name_ja
    add_column :teachers, :name_en, :string
  end
end
