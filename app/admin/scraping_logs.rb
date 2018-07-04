ActiveAdmin.register ScrapingLog do
  permit_params :post_id, :scraping_date, :exec_time, :total_comment
  filter :scraping_date
  filter :total_comment
  index do
    column :scraping_date
    column :exec_time
    column :total_comment
    column "" do |p|
      div(title: "#{p.post.title}") do
        p.post.title.truncate 70
      end
    end
  end


end
