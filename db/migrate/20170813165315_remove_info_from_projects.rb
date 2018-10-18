class RemoveInfoFromProjects < ActiveRecord::Migration[5.2]
  def change
    remove_column :projects, :name
    remove_column :projects, :description
    remove_column :projects, :slug
    remove_column :projects, :github_updated_at
    remove_column :projects, :owner_login
    remove_column :projects, :owner_avatar_url
  end
end
