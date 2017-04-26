class ChangeNameToUrlOnOrganization < ActiveRecord::Migration
  def change
    rename_column :organizations, :name, :url
  end
end
