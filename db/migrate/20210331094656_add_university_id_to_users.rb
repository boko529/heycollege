class AddUniversityIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :university, foreign_key: true, default: 1 # 既存のユーザーにはAPUを紐付けるため
  end
end
