class AddLifelogkitToMicropost < ActiveRecord::Migration[7.0]
  def change
    add_column :microposts, :lifelog_id, :integer
    add_column :microposts, :assumption_minutes, :integer
    add_column :microposts, :consuming_minutes, :integer
  end
end
