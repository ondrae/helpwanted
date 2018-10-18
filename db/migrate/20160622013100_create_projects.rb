class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :name,           null: false
      t.text :description
      t.string :url
      t.references :collection, index: true, foreign_key: true

      t.timestamps              null: false
    end
  end
end
