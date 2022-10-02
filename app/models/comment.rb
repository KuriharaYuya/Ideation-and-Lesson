class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :micropost
  has_many :likes
  validates :content, presence: true
  validates :user_id, presence: true
  validates :micropost_id, presence: true
end
