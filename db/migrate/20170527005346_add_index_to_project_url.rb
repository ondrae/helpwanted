class AddIndexToProjectUrl < ActiveRecord::Migration
  def change
    add_index :projects, :url
  end
end
