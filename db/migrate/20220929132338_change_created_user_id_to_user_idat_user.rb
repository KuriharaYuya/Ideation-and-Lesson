class ChangeCreatedUserIdToUserIdatUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :microposts, :created_user_id
    add_column :microposts, :user_id, :integer
  end
end
