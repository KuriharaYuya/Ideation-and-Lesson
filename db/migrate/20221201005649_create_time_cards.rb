class CreateTimeCards < ActiveRecord::Migration[7.0]
  def change
    create_table :time_cards do |t|
      t.datetime :scheduled_time_tomorrow
      t.datetime :scheduled_time_today
      t.datetime :arrived_time
      t.boolean :be_on_time, default: false
      t.string :proof_img
      t.integer :lifelog_id
      t.timestamps
    end
  end
end
