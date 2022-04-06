class AddTextToSubmissions < ActiveRecord::Migration[6.1]
  def change
    add_column :submissions, :text, :string, default: ""
  end
end
