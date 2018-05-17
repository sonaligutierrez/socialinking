class AddAcountsFromPosts < ActiveRecord::Migration[5.1]
  def change
    add_reference :posts, :acounts, foreign_key: true
  end
end
