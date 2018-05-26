class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.date :date
      t.text :comment
      t.references :facebook_user, foreign_key: true
      t.references :post, foreign_key: true

      t.timestamps
    end
  end
end
