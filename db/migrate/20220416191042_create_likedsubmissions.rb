class CreateLikedsubmissions < ActiveRecord::Migration[6.1]
  def change
    create_table :likedsubmissions do |t|
      t.belongs_to :user
      t.belongs_to :submission
      t.timestamps
    end
  end
end
