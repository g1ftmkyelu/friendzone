class Community < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  has_many :community_memberships, dependent: :destroy
  has_many :members, through: :community_memberships, source: :user

  validates :name, presence: true, uniqueness: true, length: { in: 3..100 }
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validates :creator_id, presence: true
end