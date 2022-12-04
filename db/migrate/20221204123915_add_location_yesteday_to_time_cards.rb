class AddLocationYestedayToTimeCards < ActiveRecord::Migration[7.0]
  def change
    add_column :time_cards, :location_yesterday, :string, limit: 40
  end
end
