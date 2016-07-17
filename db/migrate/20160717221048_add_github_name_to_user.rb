class AddGithubNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :github_name, :string
    add_column :users, :image, :string
  end
end
