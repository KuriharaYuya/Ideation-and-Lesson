class AddColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :microposts, :posted?, :boolean, default: false
    add_column :microposts, :posted_at, :datetime
  end
end
