class CreateMicroposts < ActiveRecord::Migration[7.0]
  def change
    create_table :microposts do |t|
      t.string :title
      t.integer :created_user
      t.string :explain_post
      t.string :post_type
      t.string :engagement_status
      t.datetime :start_datetime
      t.datetime :end_datetime

      t.timestamps
    end
  end
end
