class Micropost < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  validates :title, presence: true
  validates :user_id, presence: true
  validates :engagement_status, presence: true
  validates :post_type, presence: true
end
