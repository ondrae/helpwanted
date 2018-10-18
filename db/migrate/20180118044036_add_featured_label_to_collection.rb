class AddFeaturedLabelToCollection < ActiveRecord::Migration[5.2]
  def change
    add_column :collections, :featured_label, :string
  end
end
