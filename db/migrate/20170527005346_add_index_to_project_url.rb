class AddIndexToProjectUrl < ActiveRecord::Migration[5.2]
  def change
    add_index :projects, :url
  end
end
