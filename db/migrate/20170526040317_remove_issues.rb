class RemoveIssues < ActiveRecord::Migration
  def change
    drop_table :labels
    drop_table :issues
  end
end
