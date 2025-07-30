class CommunityMembership < ApplicationRecord
  belongs_to :user
  belongs_to :community

  validates :user_id, uniqueness: { scope: :community_id, message: "is already a member or has a pending request for this community" }
  validates :status, presence: true, inclusion: { in: %w(pending accepted) }

  scope :accepted, -> { where(status: 'accepted') }
  scope :pending, -> { where(status: 'pending') }
end