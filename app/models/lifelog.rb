class Lifelog < ApplicationRecord
  belongs_to :user
  has_many :microposts
  validates :log_date, uniqueness: { scope: :user_id }
  validates :title, presence: true
  validates :overview, length: { maximum: 270 }
  mount_uploader :calender, ImageUploader
  mount_uploader :screen_time, ImageUploader
end
