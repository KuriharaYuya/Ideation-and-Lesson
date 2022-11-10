class Micropost < ApplicationRecord
  belongs_to :user
  belongs_to :lifelog, optional: true
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  validates :title, presence: true, length: { maximum: 50 }
  has_many :verifications, dependent: :destroy
  has_many :notifications, dependent: :destroy
  with_options unless: :post_type_is_time_lapse? do
    validates :verified, absence: true
  end
  validates :user_id, presence: true
  validates :engagement_status, presence: true
  validates :post_type, presence: true
  mount_uploader :video, VideoUploader

  def create_notification_like_for_micropost(current_user)
    # すでに「いいね」されているか検索
    temp = Notification.where(['visitor_id = ? and visited_id = ? and micropost_id = ? and action = ? ', current_user.id,
                               user_id, id, 'like'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        micropost_id: id,
        visited_id: user_id,
        action: 'like'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      notification.checked = true if notification.visitor_id == notification.visited_id
      notification.save if notification.valid?
    end
  end

  def gap
    if consuming_minutes && assumption_minutes
      tmp = consuming_minutes - assumption_minutes
      if tmp > 0
        '+'.+ tmp.to_s + '分'
      else
        '-' + tmp.to_s + '分'
      end
    else
      0
    end
  end

  private

  def post_type_is_time_lapse?
    post_type == 'タイムラプス'
  end
end
