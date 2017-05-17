class DropOrganizations < ActiveRecord::Migration
  def up
    drop_table :organizations
  end

  def down
    create_table :organizations do |t|
      t.string :name
      t.references :collection, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
