class AddUniversityToUsers < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :university, foreign_key: true
  end
end
