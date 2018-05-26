class DeleteModelCommentary < ActiveRecord::Migration[5.1]
  def up
    drop_table :commentaries
  end

  def down
    create_table :commentaries do |t|
      t.date :date
      t.text :commentary
      t.references :facebook_users, foreign_key: true
      t.references :posts, foreign_key: true

      t.timestamps
    end
  end
end
