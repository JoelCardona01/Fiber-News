class CreateLikedcomments < ActiveRecord::Migration[6.1]
  def change
    create_table :likedcomments do |t|
     t.belongs_to :user
      t.belongs_to :comment
      t.timestamps
    end
  end
end
