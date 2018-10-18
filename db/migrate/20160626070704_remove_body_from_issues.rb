class RemoveBodyFromIssues < ActiveRecord::Migration[5.2]
  def change
    remove_column :issues, :body
  end
end
