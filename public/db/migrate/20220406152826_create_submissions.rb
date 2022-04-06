class CreateSubmissions < ActiveRecord::Migration[6.1]
  def change
    create_table :submissions do |t|
      t.string :url
      t.string :title

      t.timestamps
    end
  end
end
