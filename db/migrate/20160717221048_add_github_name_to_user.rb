class AddGithubNameToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :github_name, :string
    add_column :users, :image, :string
  end
end
