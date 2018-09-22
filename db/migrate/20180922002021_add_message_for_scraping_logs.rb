class AddMessageForScrapingLogs < ActiveRecord::Migration[5.1]
  def change
    add_column :scraping_logs, :message, :string
  end
end
