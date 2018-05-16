class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.date :date
      t.date :post_date
      t.references :post_creators, foreign_key: true
      t.references :users, foreign_key: true

      t.timestamps
    end
  end
end
