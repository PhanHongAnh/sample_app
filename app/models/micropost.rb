class Micropost < ApplicationRecord
  belongs_to :user
  scope :order_micropost, ->{order(created_at: :desc)}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length:
    {maximum: Settings.maximum.content}
  validate :picture_size

  private

  def picture_size
    if picture.size > Settings.picture.size.megabytes
      errors.add(:picture, I18n.t("picture_error"))
    end
  end
end
