class ReviseDefaultOfLifelogLogdate < ActiveRecord::Migration[7.0]
  def change
    change_column_default :lifelogs, :log_date, 'now()'
  end
end
