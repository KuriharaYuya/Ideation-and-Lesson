class ChangeColumnOfNotification < ActiveRecord::Migration[7.0]
  def change
    remove_column :notifications, :post_id
    add_column :notifications, :micropost_id, :integer
    add_index :notifications, :micropostpost_id
  end
end
