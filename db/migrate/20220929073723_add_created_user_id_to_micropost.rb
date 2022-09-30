class AddCreatedUserIdToMicropost < ActiveRecord::Migration[7.0]
  def change
    add_column :microposts, :created_user_id, :integer
  end
end
