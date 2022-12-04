class ChangeTimeCards < ActiveRecord::Migration[7.0]
  def change
    remove_column :time_cards, :location
    add_column :time_cards, :location_tomorrow, :string, limit: 40
    add_column :time_cards, :local_today, :string, limit: 40
  end
end
