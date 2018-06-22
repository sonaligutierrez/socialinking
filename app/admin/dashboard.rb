ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }


  content title: proc { I18n.t("active_admin.dashboard") } do
   columns do
    column do
       panel "Models" do
         ul do
           li link_to(I18n.t("active_admin.accounts"), admin_users_path)
           li link_to(I18n.t("active_admin.categories"), admin_categories_path)
           li link_to(I18n.t("active_admin.facebook_users"), admin_facebook_users_path)
           li link_to(I18n.t("active_admin.post_creators"), admin_post_creators_path)
           li link_to(I18n.t("active_admin.posts"), admin_posts_path)
           li link_to(I18n.t("active_admin.scraping_logs"), admin_scraping_logs_path)
           li link_to(I18n.t("active_admin.users"), admin_users_path)
         end
       end
     end
  end

 end # content
end
