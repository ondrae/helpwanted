class ChangeNullConstraintsOnProjects < ActiveRecord::Migration[5.2]
  def change
    change_column_null(:projects, :name, true)
    change_column_null(:projects, :url, false)
  end
end
