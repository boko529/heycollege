class UserGroupRelation < ApplicationRecord
  belongs_to :user, class_name: "User"
  belongs_to :group, class_name: "Group"
end
