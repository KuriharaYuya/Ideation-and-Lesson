class AddDefaultToLifelogTitle < ActiveRecord::Migration[7.0]
  def change
    change_column_default :lifelogs, :title, 'Untitled'
  end
end
