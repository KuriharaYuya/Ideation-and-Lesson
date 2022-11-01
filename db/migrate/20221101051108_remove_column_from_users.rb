class RemoveColumnFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :posted?
    remove_column :users, :posted_at
  end
end
