class AddFeaturedToIssues < ActiveRecord::Migration[5.2]
  def change
    add_column :issues, :featured, :boolean, default: false
  end
end
