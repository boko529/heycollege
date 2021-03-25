class DeleteGroupProfiles < ActiveRecord::Migration[6.1]
  def change
    # group_profileテーブル削除します.
    # 代わりにgroupテーブルにprofile(text型)カラムを追加してます.
    drop_table :group_profiles
  end
end
