class RemoveLocalTodayFromTimeCards < ActiveRecord::Migration[7.0]
  def change
    remove_column :time_cards, :local_today
  end
end
