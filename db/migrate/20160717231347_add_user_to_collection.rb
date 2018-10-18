class AddUserToCollection < ActiveRecord::Migration[5.2]
  def change
    add_reference :collections, :user, index: true, foreign_key: true
  end
end
