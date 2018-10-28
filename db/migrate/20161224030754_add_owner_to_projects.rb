class AddOwnerToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :owner_login, :string
    add_column :projects, :owner_avatar_url, :string
  end
end
