class RemoveIssues < ActiveRecord::Migration[5.2]
  def change
    drop_table :labels
    drop_table :issues
  end
end
