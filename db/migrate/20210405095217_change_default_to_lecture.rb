class ChangeDefaultToLecture < ActiveRecord::Migration[6.1]
  def change
    change_column_default :lectures, :lecture_lang, from: 1, to: nil
    change_column_default :lectures, :field, from: 1, to: nil
  end
end
