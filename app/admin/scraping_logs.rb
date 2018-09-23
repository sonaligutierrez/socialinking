ActiveAdmin.register ScrapingLog do
  permit_params :post_id, :scraping_date, :exec_time, :total_comment
  filter :scraping_date
  filter :total_comment
  menu label: proc { I18n.t("active_admin.scraping_logs") }, priority: 6
  index do
    column :scraping_date
    column :exec_time_in_hours
    column :total_comment
    column "Post" do |p|
      link_to(p.post.title&.truncate(70).to_s, p.post.url, target: "_blank")
    end
    column :message
  end
end
