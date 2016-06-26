class ChangeNullConstraintsOnProjects < ActiveRecord::Migration
  def change
    change_column_null(:projects, :name, true)
    change_column_null(:projects, :url, false)
  end
end
