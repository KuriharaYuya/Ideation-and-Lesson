class AddGapMinToTimeCard < ActiveRecord::Migration[7.0]
  def change
    add_column :time_cards, :gap_min, :integer
  end
end
