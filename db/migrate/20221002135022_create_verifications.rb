class CreateVerifications < ActiveRecord::Migration[7.0]
  def change
    create_table :verifications do |t|
      t.integer :user_id
      t.integer :micropost_id

      t.timestamps
    end
  end
end
