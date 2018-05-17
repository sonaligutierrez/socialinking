class CreateScrapingLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :scraping_logs do |t|
      t.date :scraping_date
      t.time :exec_time
      t.integer :total_comment
      t.references :posts, foreign_key: true

      t.timestamps
    end
  end
end
