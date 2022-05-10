class CreateSubmissions < ActiveRecord::Migration[6.1]
  def change
    create_table :submissions do |t|
      t.belongs_to :user
      t.string :url, default: ""
      t.string :title
      t.timestamps
    end
  end
end
