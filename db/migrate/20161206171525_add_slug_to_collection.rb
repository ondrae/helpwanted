class AddSlugToCollection < ActiveRecord::Migration
  def change
    add_column :collections, :slug, :string
    add_index :collections, :slug, unique: true
  end
end
