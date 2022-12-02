class Lifelog < ApplicationRecord
  belongs_to :user
  has_many :microposts
  has_one :time_card, dependent: :destroy
  validates :log_date, uniqueness: { scope: :user_id }
  validates :title, presence: true
  validates :overview, length: { maximum: 200 }
  mount_uploader :calender, ImageUploader
  mount_uploader :screen_time, ImageUploader

  def consuming_minutes
    microposts.sum(:consuming_minutes)
  end
end
