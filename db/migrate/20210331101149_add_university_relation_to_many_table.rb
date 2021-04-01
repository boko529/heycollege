class AddUniversityRelationToManyTable < ActiveRecord::Migration[6.1]
  def change
    add_column :lectures, :type, :string, default: Apu::Lecture, null: false # LectureをSTIに
    add_reference :groups, :university, foreign_key: true, default: 1 # 既存のユーザーにはAPUを紐付けるため
    add_reference :lectures, :university, foreign_key: true, default: 1 # 既存のユーザーにはAPUを紐付けるため
    add_reference :news, :university, foreign_key: true, default: 1 # 既存のユーザーにはAPUを紐付けるため
    add_reference :teachers, :university, foreign_key: true, default: 1 # 既存のユーザーにはAPUを紐付けるため
    add_reference :zooms, :university, foreign_key: true
  end
end
