class Lifelog < ApplicationRecord
  belongs_to :user
  has_many :microposts
  # validates :date, presence: true
end
