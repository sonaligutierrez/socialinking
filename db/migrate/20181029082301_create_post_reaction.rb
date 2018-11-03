class CreatePostReaction < ActiveRecord::Migration[5.1]
  def change
    create_table :post_reactions do |t|
      t.text :reaction
      t.references :facebook_users, foreign_key: true
      t.references :posts, foreign_key: true

      t.timestamps
    end
  end
end
