class AddVerifiedToMicropost < ActiveRecord::Migration[7.0]
  def change
    add_column :microposts, :verified, :boolean
  end
end
