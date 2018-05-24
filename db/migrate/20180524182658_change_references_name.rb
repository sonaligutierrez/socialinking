class ChangeReferencesName < ActiveRecord::Migration[5.1]
  def self.up
  	remove_foreign_key :posts, column: :accounts_id
  	remove_column :posts, :accounts_id
  	add_reference :posts, :account, foreign_key: true

  	remove_foreign_key :posts, column: :post_creators_id
  	remove_column :posts, :post_creators_id
  	add_reference :posts, :post_creator, foreign_key: true

  	remove_foreign_key :scraping_logs, column: :posts_id
  	remove_column :scraping_logs, :posts_id
  	add_reference :scraping_logs, :post, foreign_key: true


  end

  def self.down
  	remove_foreign_key :posts, :account, foreign_key: true
  	add_reference :posts, column: :accounts_id, foreign_key: true

  	remove_foreign_key :posts, :post_creator, foreign_key: true
  	add_reference :posts, column: :post_creators, foreign_key: true

	remove_foreign_key :scraping_logs, :post, foreign_key: true
  	add_reference :scraping_logs, column: :posts, foreign_key: true

  end
end
