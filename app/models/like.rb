class Like < ApplicationRecord
  belongs_to :user
  belongs_to :micropost, optional: true
  belongs_to :comment, optional: true
  validates :user_id, presence: true

  with_options if: :comment_belongs? do
    validates :micropost_id, absence: true
    validates :comment_id, presence: true
  end

  with_options unless: :comment_belongs? do
    validates :micropost_id, presence: true
    validates :comment_id, absence: true
  end

  with_options if: :micropost_belongs? do
    validates :comment_id, absence: true
    validates :micropost_id, presence: true
  end

  with_options unless: :micropost_belongs? do
    validates :comment_id, presence: true
    validates :micropost_id, absence: true
  end

  private

  def comment_belongs?
    !comment_id.nil?
  end

  def micropost_belongs?
    !micropost_id.nil?
  end
end
