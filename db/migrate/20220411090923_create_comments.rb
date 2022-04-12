class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.string :text
      t.integer :postid
      t.integer :parentid
      t.integer :likes, default:0

      t.timestamps
    end
  end
end
