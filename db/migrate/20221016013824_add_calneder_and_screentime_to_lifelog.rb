class AddCalnederAndScreentimeToLifelog < ActiveRecord::Migration[7.0]
  def change
    add_column :lifelogs, :calender, :string
    add_column :lifelogs, :screen_time, :string
    # Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
