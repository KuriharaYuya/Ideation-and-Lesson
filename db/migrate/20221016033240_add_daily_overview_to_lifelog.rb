class AddDailyOverviewToLifelog < ActiveRecord::Migration[7.0]
  def change
    add_column :lifelogs, :overview, :string
  end
end
