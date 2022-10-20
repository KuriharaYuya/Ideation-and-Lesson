class AddForggottenMigrations < ActiveRecord::Migration[7.0]
  def change
    add_column :lifelogs, :tweeted?, :boolean, default: false
    add_column :lifelogs, :assumption_minutes, :integer, 
    create_table :user_settings do |t|
      t.integer :user_id
      t.integer :tweet_lifelog_date,default: 1
    
      t.timestamps
    end
    add_column :users, :admin, :boolean, default: false
  end
end
