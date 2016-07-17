class AddUserToCollection < ActiveRecord::Migration
  def change
    add_reference :collections, :user, index: true, foreign_key: true
  end
end
