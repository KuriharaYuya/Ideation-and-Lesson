class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 70 }
  validates :email, presence: true, length: { maximum: 30 }
  validates :password, presence: true,length: {minimum:6}
  has_secure_password
  #これは付け加えるだけで勝手にpassword(digest)を暗号化してくれる
end

# validates :name, presence: true, length: { maximum: 70 }
#   validates :email, presence: true, length: { maximum: 30 },inclusion: {in: %w(@)}
