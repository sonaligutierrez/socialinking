class CreatePostShared < ActiveRecord::Migration[5.1]
  def change
    create_table :post_shared do |t|
      t.references :facebook_users, foreign_key: true
      t.references :posts, foreign_key: true

      t.timestamps
    end
  end
end
