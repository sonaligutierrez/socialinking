ActiveAdmin.register ScrapingLog do
  permit_params :post_id, :scraping_date, :exec_time, :total_comment

  index do
    column :scraping_date
    column :exec_time
    column :total_comment
    column :post
  end

end
