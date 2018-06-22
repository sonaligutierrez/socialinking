class ChangeDateColumsInScrapingLogs < ActiveRecord::Migration[5.1]
  def change
    change_column :scraping_logs, :scraping_date, :datetime
  end
end
