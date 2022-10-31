class AddPostLifelogIdToUsersetting < ActiveRecord::Migration[7.0]
  def change
    add_column :user_settings, :post_lifelog_id, :integer
  end
end
