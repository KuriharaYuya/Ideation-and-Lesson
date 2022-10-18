class RemoveCreatedUserFromUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :microposts, :created_user, :integer
  end
end
