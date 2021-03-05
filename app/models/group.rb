class Group < ApplicationRecord
    validates :name, presence: true, uniqueness: true
    has_many :passive_relations, class_name: "UserGroupRelation",
                                 foreign_key: "group_id"
    has_many :users, through: :passive_relations
    has_one :group_point, dependent: :destroy
end