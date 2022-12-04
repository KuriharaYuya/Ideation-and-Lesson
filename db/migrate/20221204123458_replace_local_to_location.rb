class ReplaceLocalToLocation < ActiveRecord::Migration[7.0]
  def change
    add_column :time_cards, :location_today, :string, limit: 40
    # Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
