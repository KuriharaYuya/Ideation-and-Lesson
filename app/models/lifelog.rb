class Lifelog < ApplicationRecord
  belongs_to :user
  has_many :microposts
  validates :log_date, uniqueness: { scope: :user_id }
  validates :title, presence: true
end
