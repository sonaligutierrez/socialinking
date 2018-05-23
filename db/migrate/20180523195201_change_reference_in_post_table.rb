class ChangeReferenceInPostTable < ActiveRecord::Migration[5.1]
  def self.up
  	remove_foreign_key :posts, column: :acounts_id
  	remove_column :posts, :acounts_id
  	add_reference :posts, :accounts, foreign_key: true
  end
  def self.down
  	remove_foreign_key :posts, :accounts, foreign_key: true
  	add_reference :posts, column: :acounts_id
  end
end
