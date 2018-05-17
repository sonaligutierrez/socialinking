class RemoveUsersFromPosts < ActiveRecord::Migration[5.1]
  def change
    remove_reference :posts, :users, foreign_key: true
  end
end
