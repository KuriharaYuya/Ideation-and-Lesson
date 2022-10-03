class SetDefaultToMicropostVerified < ActiveRecord::Migration[7.0]
  def change
    change_column_default :microposts, :verified, from: nil, to: false
  end
end
