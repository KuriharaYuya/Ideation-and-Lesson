class AddUserIdToLigelog < ActiveRecord::Migration[7.0]
  def change
    add_column :lifelogs, :user_id, :integer
  end
end
