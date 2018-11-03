class CreatePostCreatorLikes < ActiveRecord::Migration[5.1]
  def change
    create_table :post_creator_likes do |t|
      t.references :facebook_users, foreign_key: true
      t.references :post_creators, foreign_key: true
      t.timestamps
    end
  end
end
