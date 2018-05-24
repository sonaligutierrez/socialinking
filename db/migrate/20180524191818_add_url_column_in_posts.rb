class AddUrlColumnInPosts < ActiveRecord::Migration[5.1]
  def change
  	add_column :posts, :url, :string
  end
end
