class CreateLifelogs < ActiveRecord::Migration[7.0]
  def change
    create_table :lifelogs do |t|
      t.string :title
      t.date :log_date
      t.datetime :start_datetime
      t.datetime :end_datetime

      t.timestamps
    end
  end
end
