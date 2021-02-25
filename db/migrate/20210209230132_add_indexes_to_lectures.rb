class AddIndexesToLectures < ActiveRecord::Migration[6.1]
  def change
    # add_index :lectures, [:lecture_size, :lecture_term, :lecture_type, :language_used, :group_work]
    add_index :lectures, :lecture_size
    add_index :lectures, :lecture_term
    add_index :lectures, :lecture_type
    add_index :lectures, :language_used
    add_index :lectures, :group_work

  end
end
