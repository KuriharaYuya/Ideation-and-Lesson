class AddAsptimeToLifelogs < ActiveRecord::Migration[7.0]
  def change
    add_column :lifelogs, :assumption_minutes, :integer
  end
end
