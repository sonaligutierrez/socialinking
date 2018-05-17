class CreateCommentaries < ActiveRecord::Migration[5.1]
  def change
    create_table :commentaries do |t|
      t.date :date
      t.text :commentary
      t.references :facebook_users, foreign_key: true

      t.timestamps
    end
  end
end
