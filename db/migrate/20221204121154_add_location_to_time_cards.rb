class AddLocationToTimeCards < ActiveRecord::Migration[7.0]
  def change
    add_column :time_cards, :location, :string
  end
end
