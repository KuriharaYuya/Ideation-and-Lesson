class AddVideoToMicropost < ActiveRecord::Migration[7.0]
  def change
    add_column :microposts, :video, :string
  end
end
