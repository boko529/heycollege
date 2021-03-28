class ChangeColumnsToLectures < ActiveRecord::Migration[6.1]
  def change
    add_column :lectures, :lecture_lang, :integer, default: 1
    add_column :lectures, :field, :integer, default: 1
    add_index :lectures, :lecture_lang
    add_index :lectures, :field
    add_index :lectures, :name_en
  end
end
