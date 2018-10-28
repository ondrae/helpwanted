class ChangeNameToUrlOnOrganization < ActiveRecord::Migration[5.2]
  def change
    rename_column :organizations, :name, :url
  end
end
