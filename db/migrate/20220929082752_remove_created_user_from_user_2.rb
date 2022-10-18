class RemoveCreatedUserFromUser2 < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :created_user
  end
end
