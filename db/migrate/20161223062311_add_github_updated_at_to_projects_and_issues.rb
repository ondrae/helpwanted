class AddGithubUpdatedAtToProjectsAndIssues < ActiveRecord::Migration
  def change
    add_column :projects, :github_updated_at, :datetime
    add_column :issues, :github_updated_at, :datetime
  end
end
