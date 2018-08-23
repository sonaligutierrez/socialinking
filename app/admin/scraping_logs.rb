ActiveAdmin.register ScrapingLog do
  permit_params :post_id, :scraping_date, :exec_time, :total_comment
  filter :scraping_date
  filter :total_comment
  menu label: proc { I18n.t("active_admin.scraping_logs") }, priority: 6 if proc { current_user.admin? }
  index do
    column :scraping_date
    column :exec_time_in_hours
    column :total_comment
    column "" do |p|
      div(title: "#{p.post.title}") do
        p.post.title&.truncate 70
      end
    end
  end


end
