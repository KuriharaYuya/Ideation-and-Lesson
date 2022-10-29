class User < ApplicationRecord
  has_many :lifelogs
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :microposts, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :verifications, dependent: :destroy
  has_one :user_setting, dependent: :destroy

  validates :name, presence: true, length: { maximum: 70 }
  validates :email, presence: true, length: { maximum: 30 }, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  has_secure_password
  attr_accessor :remember_token

  # これは付け加えるだけで勝手にpassword(digest)を暗号化してくれる

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost:)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  def authenticated?(remember_token)
    # 「ハッシュ化したremember_token == remember_digest」 を聞いてる
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end
