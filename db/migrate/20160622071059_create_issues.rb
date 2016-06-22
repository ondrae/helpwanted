class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :title
      t.string :url
      t.text :body
      t.string :labels, array: true
      t.references :project, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
