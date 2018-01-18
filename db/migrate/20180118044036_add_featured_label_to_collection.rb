class AddFeaturedLabelToCollection < ActiveRecord::Migration
  def change
    add_column :collections, :featured_label, :string
  end
end
