class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :user_id, uniqueness: { scope: :friend_id, message: "already sent a friend request to this user" }
  validates :status, presence: true, inclusion: { in: %w(pending accepted) }

  # Ensure a user cannot friend themselves
  validate :not_self_friendship

  private

  def not_self_friendship
    errors.add(:friend, "can't be the same as the user") if user_id == friend_id
  end
end