class CreateUserSetting < ActiveRecord::Migration[7.0]
  def change
    create_table :user_settings do |t|
      t.integer :user_id
      t.integer :tweet_lifelog_date, default: 1
      t.timestamps
    end
  end
end
