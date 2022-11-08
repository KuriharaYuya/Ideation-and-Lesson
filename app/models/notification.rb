class Notification < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  belongs_to :micropost, optional: true
  belongs_to :comment, optional: true

  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true

  def action?
    'いいね' if action == 'like'
  end

  def visitor
    User.find(visitor_id)
  end

  def content?
    if micropost_id.present?
      Micropost.find(micropost_id)
    elsif comment_id.present?
      Comment.find(comment_id)
    end
  end
end
