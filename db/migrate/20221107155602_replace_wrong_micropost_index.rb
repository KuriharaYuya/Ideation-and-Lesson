class ReplaceWrongMicropostIndex < ActiveRecord::Migration[7.0]
  def change
    remove_index :notifications, name: :index_notifications_on_micropostpost_id
    add_index :notifications, :micropost_id
  end
end
