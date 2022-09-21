class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 70 }
  validates :email, presence: true, length: { maximum: 30 }
  validates :password, presence: true,length: {minimum:6}
  has_secure_password
  #これは付け加えるだけで勝手にpassword(digest)を暗号化してくれる
end

def User.digest(string)
  cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
    BCrypt::Engine.cost
  BCrypt::Password.create(string, cost: cost)
end
