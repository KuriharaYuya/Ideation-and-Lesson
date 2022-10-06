class Micropost < ApplicationRecord
  belongs_to :user
  belongs_to :lifelog, optional: true
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  validates :title, presence: true
  has_many :verifications, dependent: :destroy
  with_options unless: :post_type_is_time_lapse? do
    validates :verified, absence: true
  end
  validates :user_id, presence: true
  validates :engagement_status, presence: true
  validates :post_type, presence: true

  private

  def post_type_is_time_lapse?
    post_type == 'タイムラプス'
  end
end
