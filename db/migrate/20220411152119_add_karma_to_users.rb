class AddKarmaToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :karma, :integer
  end
end
