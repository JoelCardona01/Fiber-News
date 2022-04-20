class ChangeKarmaDefault < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :karma, 0
  end
end
