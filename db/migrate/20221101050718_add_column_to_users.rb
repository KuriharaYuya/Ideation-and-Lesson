class AddColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :posted?, :boolean, default: false
    add_column :users, :posted_at, :datetime
  end
end
