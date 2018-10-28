class RemoveLabelsFromIssue < ActiveRecord::Migration[5.2]
  def change
    remove_column :issues, :labels
  end
end
