class MoveStateToLectureInfos < ActiveRecord::Migration[6.1]
  def change
    remove_column :lectures, :state
    add_column :lecture_infos, :state, :integer
    add_index :lecture_infos, :state
  end
end
