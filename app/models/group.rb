class Group < ApplicationRecord
    # Point関係のメソッドはgroup/point.rbに記載
    include Group::Point
    validates :name, presence: true, uniqueness: true
    has_many :passive_relations, class_name: "UserGroupRelation",
                                 foreign_key: "group_id"
    has_many :users, through: :passive_relations
    has_one :group_point, dependent: :destroy
    has_many :group_point_history, dependent: :destroy
    has_one :group_profile, dependent: :destroy
end