class AddViewedClickedToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :viewed, :integer, default: 0
    add_column :issues, :clicked, :integer, default: 0
  end
end
