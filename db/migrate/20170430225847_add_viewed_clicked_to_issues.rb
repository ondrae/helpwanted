class AddViewedClickedToIssues < ActiveRecord::Migration[5.2]
  def change
    add_column :issues, :viewed, :integer, default: 0
    add_column :issues, :clicked, :integer, default: 0
  end
end
