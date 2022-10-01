class Micropost < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :microposts, dependent: :destroy
  validates :title, presence: true
  validates :user_id, presence: true
  validates :engagement_status, presence: true
  validates :post_type, presence: true
end
