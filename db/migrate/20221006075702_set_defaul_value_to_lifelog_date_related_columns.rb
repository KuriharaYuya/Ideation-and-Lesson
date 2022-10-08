class SetDefaulValueToLifelogDateRelatedColumns < ActiveRecord::Migration[7.0]
  def change
    change_column_default :lifelogs, :log_date, DateTime.now
  end
end
