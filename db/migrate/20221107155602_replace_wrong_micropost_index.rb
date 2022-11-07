class ReplaceWrongMicropostIndex < ActiveRecord::Migration[7.0]
  def change
    add_index :notifications, :micropost_id
  end
end
