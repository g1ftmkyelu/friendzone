class User < ApplicationRecord
  has_secure_password

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  # Friendships where this user is the sender
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships, source: :friend

  # Friendships where this user is the receiver (inverse)
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id', dependent: :destroy
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  # Messages
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_messages, class_name: 'Message', foreign_key: 'receiver_id', dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true, length: { in: 3..50 }, format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only allows letters, numbers, and underscores" }
  validates :bio, length: { maximum: 500 }, allow_blank: true
  validates :avatar, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "must be a valid URL" }, allow_blank: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  # Helper method to check friendship status
  def friendship_status_with(other_user)
    return nil if self == other_user

    # Check if there's an accepted friendship in either direction
    if friendships.exists?(friend: other_user, status: 'accepted') || inverse_friendships.exists?(user: other_user, status: 'accepted')
      'friends'
    # Check if a pending request was sent by current_user
    elsif friendships.exists?(friend: other_user, status: 'pending')
      'pending_outgoing'
    # Check if a pending request was received by current_user
    elsif inverse_friendships.exists?(user: other_user, status: 'pending')
      'pending_incoming'
    else
      'not_friends'
    end
  end

  def all_friends
    (friends.where(friendships: { status: 'accepted' }) + inverse_friends.where(inverse_friendships: { status: 'accepted' })).uniq
  end

  # Class method for searching users
  def self.search_by_query(query)
    where("username LIKE ? OR name LIKE ?", "%#{query}%", "%#{query}%")
  end

  # Instance method to get recommended users (not friends, not pending, not self)
  def recommended_users(limit: 5)
    # Get IDs of current user, accepted friends, and users with pending requests (both ways)
    excluded_ids = [self.id] +
                   self.all_friends.pluck(:id) +
                   self.friendships.where(status: 'pending').pluck(:friend_id) +
                   self.inverse_friendships.where(status: 'pending').pluck(:user_id)

    # Find users not in the excluded_ids list, order randomly, and limit
    User.where.not(id: excluded_ids.uniq)
        .order(Arel.sql('RANDOM()')) # RANDOM() for SQLite
        .limit(limit)
  end
end