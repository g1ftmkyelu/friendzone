class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :content, presence: true, length: { maximum: 1000 }, unless: :image_url?
  validates :image_url, presence: true, unless: :content?
  validates :user_id, presence: true

  # Custom validation to ensure at least one of content or image_url is present
  validate :content_or_image_present

  private

  def content_or_image_present
    if content.blank? && image_url.blank?
      errors.add(:base, "Post must have either content or an image.")
    end
  end
end