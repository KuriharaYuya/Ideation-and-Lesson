class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 70 }
  validates :email, presence: true, length: { maximum: 30 }
end

# validates :name, presence: true, length: { maximum: 70 }
#   validates :email, presence: true, length: { maximum: 30 },inclusion: {in: %w(@)}
