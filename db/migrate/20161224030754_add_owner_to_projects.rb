class AddOwnerToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :owner_login, :string
    add_column :projects, :owner_avatar_url, :string
  end
end
