class RemoveDefaultValueOfLifelogLogdate < ActiveRecord::Migration[7.0]
  def change
    change_column :lifelogs, :log_date, :date
  end
end
