class ChangeAboutDefault < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :about, ""
  end
end
