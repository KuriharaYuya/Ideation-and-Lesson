class ChangeExecdateToMicropost < ActiveRecord::Migration[7.0]
  def change
    remove_column :lifelogs, :exec_date
    add_column :microposts, :exec_date, :date
  end
end
