class AddPostsToCommentary < ActiveRecord::Migration[5.1]
  def change
    add_reference :commentaries, :posts, foreign_key: true
  end
end
